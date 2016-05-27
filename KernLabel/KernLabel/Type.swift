//
//  Type.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


private let kScreenScale = UIScreen.mainScreen().scale
private let kCGColorSpace = CGColorSpaceCreateDeviceRGB()
private let kCGImageAlphaInfo = CGImageAlphaInfo.PremultipliedLast.rawValue
private let kCharactersHaveLeftSpace = [
    "「", "『", "【", "《", "〈", "〔", "｛", "（", "［"
]
private let kCharactersHaveRightSpace = [
    "」", "』", "】", "》", "〉", "〕", "｝", "）", "］",
    "、", "。", "，", "．"
]
private let kCGFloatHuge: CGFloat = pow(2, 16)


struct Type {

    /// フォント
    let font: UIFont

    /// フォントサイズ
    let fontSize: CGFloat

    /// 行間
    let lineHeight: CGFloat

    /// 幅
    let width: CGFloat

    /// 高さ
    let height: CGFloat

    /// 開始座標
    let startPosition: CGPoint

    /// オプション
    let options: NSStringDrawingOptions

    /// truncate 字の文字列
    let truncateText: String

    /// 何行まで許容するか
    let numberOfLines: Int

    /// 現在の位置
    var currentPosition: CGPoint

    /// truncate 文字の rect
    var truncateRect: CGRect

    /// 現在の行番 (最初から何行目?)
    var lines: Int

    /// 現在の位置 (最初から何文字目?)
    var location: Int

    /// 文字列の長さ
    var length: Int

    /// attributedText
    var attributedText: NSMutableAttributedString

    /// typesetter
    var typesetter: CTTypesetter

    /// cache
    var typedContext: CGContext?

    /// 実際のテキストサイズ
    var intrinsicTextSize: CGSize?

    // フォントの半分の大きさ
    var fontHalfWidth: CGFloat {
        return self.fontSize / 2
    }


    init(attributedText: NSAttributedString, rect: CGRect, numberOfLines: Int, options: NSStringDrawingOptions, truncateText: String = "...") {
        self.attributedText = NSMutableAttributedString(attributedString: attributedText).kerned
        self.typesetter = CTTypesetterCreateWithAttributedString(self.attributedText)
        self.font = self.attributedText.font
        self.fontSize = self.font.pointSize
        self.lineHeight = self.attributedText.lineHeight
        self.width = rect.size.width
        self.height = rect.size.height
        self.startPosition = CGPointMake(
            options.contains(.UsesLineFragmentOrigin) ? rect.origin.x : 0,
            options.contains(.UsesLineFragmentOrigin) ? rect.origin.y : 0)
        self.currentPosition = CGPointZero
        self.truncateRect = NSString(string: truncateText).boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.min), options: NSStringDrawingOptions(), attributes: attributedText.attributes, context: nil)
        self.lines = 0
        self.location = 0
        self.length = self.attributedText.length
        self.options = options
        self.truncateText = truncateText
        self.numberOfLines = numberOfLines
    }

    func createEmptyContext(context: CGContext? = nil) -> CGContext {
        if let context = context {
            return context
        }
        let c = CGBitmapContextCreate(
            nil,
            Int(self.width * kScreenScale),
            Int(self.height * kScreenScale),
            8,
            0,
            kCGColorSpace,
            kCGImageAlphaInfo)!
        return c
    }

    /**
     y の開始位置を移動
     */
    private mutating func goToNextLinePosition() {
        self.currentPosition.y += self.lineHeight
    }

    /**
     行頭の文字を取得
     */
    private func getLineHead() -> String {
        return self.attributedText.attributedSubstringFromRange (NSMakeRange(self.location, 1)).string
    }

    /**
     行頭オフセットを取得。カーニング対象文字の場合は、半角分のオフセット
     */
    private func getOffset(lineHead: String? = nil) -> CGFloat {
        return kCharactersHaveLeftSpace.contains(lineHead ?? self.getLineHead()) ? self.fontHalfWidth : 0
    }

    /**
     行末から offset を計算する
     */
    private func getOffsetTail(range: NSRange) -> CGFloat {
        guard let alignment = self.attributedText.textAlignment else {
            return 0
        }
        let location = range.location + range.length
        var tail = ""
        if location <= self.attributedText.length {
            tail = self.attributedText.attributedSubstringFromRange(NSMakeRange(location - 1, 1)).string
        }
        var offset: CGFloat = 0
        switch alignment {
        case .Right:
            offset -=
                (
                    (kCharactersHaveRightSpace.contains(tail) ? self.fontHalfWidth : 0) +
                        (self.width - self.attributedText.attributedSubstringFromRange(range).boundingRect(
                        options: [.UsesLineFragmentOrigin], context: nil).size.width)
                )
        case .Center:
            offset -=
                (
                    (kCharactersHaveRightSpace.contains(tail) ? self.fontHalfWidth : 0) +
                    (self.width - self.attributedText.attributedSubstringFromRange(range).boundingRect(
                        options: [.UsesLineFragmentOrigin], context: nil).size.width)
                ) / 2
        default:
            break
        }
        return offset
    }

    /**
     offset を考慮したうえで、現在の行には何文字入るか？
     */
    private func getSuggestedLineCount(offset: CGFloat? = nil) -> Int {
        return CTTypesetterSuggestLineBreak(self.typesetter, self.location, Double(self.width + (offset ?? self.getOffset())))
    }

    /**
     現在行の、全体におけるレンジ
     */
    private func getCurrentLineRange(currentLineCount: Int? = nil) -> NSRange {
        return NSMakeRange(
            self.location,
            currentLineCount ?? self.getSuggestedLineCount(self.getOffset()))
    }

    /** 
     次の行が指定した高さを超えるか or 行数制限を超えるか
     */
    private func isOverflow(currentLineCount: Int? = nil) -> Bool {
        let surplus = self.location + (currentLineCount ?? self.getSuggestedLineCount()) < self.length
        let heightShortage = self.currentPosition.y + self.lineHeight > self.height
        let exceedNumberOfLines = self.numberOfLines == 0 ? false : self.lines + 1 >= self.numberOfLines
        return exceedNumberOfLines || (surplus && heightShortage)
    }

    /**
     truncate する行の文字数 (truncate 文字列を含まない)
     */
    private func getTruncateLineCount(offset: CGFloat? = nil) -> Int {
        return CTTypesetterSuggestLineBreak(
            self.typesetter,
            self.location,
            Double(self.width + (offset ?? self.getOffset()) - self.truncateRect.size.width))
    }

    /**
     truncate がスタートする位置
     */
    private func getTruncateStartLocation(truncateLineCount: Int? = nil) -> Int {
        return (truncateLineCount ?? self.getTruncateLineCount()) + self.location
    }

    private func draw(range: NSRange, offset: CGFloat, on context: CGContext) {

        // 反転をもどす
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1))

        // 描画開始位置を設定。offsetで行頭約物の位置を修正
        CGContextSetTextPosition(
            context,
            self.startPosition.x + self.currentPosition.x - offset,
            self.startPosition.y + self.currentPosition.y)

        // 行を描画
        let ctline = CTTypesetterCreateLine(
            self.typesetter, CFRangeMake(range.location, range.length))
        CTLineDraw(ctline, context)
    }

    private mutating func goToNextLine(count: Int) {
        self.location += count
        self.lines += 1
    }

    private mutating func process(context: CGContext?) -> CGContext? {
        let context = context ?? self.createEmptyContext()

        while self.location < self.length {
            self.goToNextLinePosition()
            var offset = self.getOffset()
            var currentLineCount = self.getSuggestedLineCount(offset)
            var range = self.getCurrentLineRange(currentLineCount)


            // 押し出し禁則を適用する
            if (self.width - self.attributedText.attributedSubstringFromRange(range).boundingWidth(options: [], context: nil)) >= (self.fontSize * 1.25) {  // kCharactersHaveRightSpace は 0.25 文字として計算
                if range.location + range.length + 2 <= self.length {
                    if kCharactersHaveRightSpace.contains(self.attributedText.attributedSubstringFromRange(NSMakeRange(range.location + range.length + 1, 1)).string) {
                        range = NSMakeRange(range.location, range.length + 2)
                        currentLineCount = range.length
                    }
                }
            }


            let overflow = self.isOverflow(currentLineCount)

            // overflow していて、 truncate する必要があるとき
            if overflow && self.options.contains(.TruncatesLastVisibleLine) {
                let truncateLineCount = self.getTruncateLineCount(offset)
                let truncateStartLocation = self.getTruncateStartLocation(truncateLineCount)
                self.attributedText.deleteCharactersInRange(
                    NSMakeRange(truncateStartLocation, self.attributedText.length - truncateStartLocation))
                self.attributedText.replaceCharactersInRange(
                    NSMakeRange(truncateStartLocation, 0), withString: self.truncateText)
                range = NSMakeRange(self.location, truncateLineCount + self.truncateText.length)
                self.typesetter = CTTypesetterCreateWithAttributedString(self.attributedText)
            }

            // 末尾文字列を考慮して先頭のオフセットを減算
            offset += self.getOffsetTail(range)

            self.draw(range, offset: offset, on: context)

            // 次の行が指定した高さを超える場合は終了
            if overflow {
                break
            }

            // 次の行へ
            self.goToNextLine(currentLineCount)
        }

        // キャッシュ
        self.typedContext = context
        self.intrinsicTextSize = CGSizeMake(
            self.width, self.currentPosition.y + self.font.ascender)

        return context
    }

    mutating func drawText(on context: CGContext) {
        self.process(context)
    }

    mutating func createDrawedImage() -> CGImage? {
        if let typedContext = self.typedContext {
            return CGBitmapContextCreateImage(typedContext)
        }
        guard let context = self.process(nil) else {
            return nil
        }
        return CGBitmapContextCreateImage(context)
    }
}
