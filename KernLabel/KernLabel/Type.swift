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
private let kCharactersCanBurasagari = [
    "、", "。", "，", "．"
]
private let kCharactersCanOikomi = [
    "」", "』", "】", "》", "〉", "〕", "｝", "）", "］",
]
private let kCharacterHaveRightSpaceRatio: CGFloat = 0.4  // 右半分が空白な文字の、fontSize における実質的な幅の割合
let kCGFloatHuge: CGFloat = pow(2, 12)


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

    /// 実際のテキストサイズ
    var intrinsicTextSize = CGSizeZero

    /// フォントの半分の大きさ
    var fontHalfWidth: CGFloat {
        return self.fontSize / 2
    }

    var padding: UIEdgeInsets = UIEdgeInsetsZero

    var verticalAlignment = KernLabelVerticalAlignment.Middle

    /// 現時点での最長の一行の長さ
    var currentLongestTypographicWidth: CGFloat {
        get {
            return self._currentLongestTypographicWidth
        }
        set {
            if newValue > self._currentLongestTypographicWidth {
                self._currentLongestTypographicWidth = newValue
            }
        }
    }
    private var _currentLongestTypographicWidth: CGFloat = 0

    init(
        attributedText: NSAttributedString,
        rect: CGRect,
        kerningSettings: KerningSettings = KernLabelKerningMode.Normal.kerningSettings,
        numberOfLines: Int = 0,
        options: NSStringDrawingOptions = .UsesLineFragmentOrigin,
        padding: UIEdgeInsets = UIEdgeInsetsZero,
        truncateText: String = "...",
        verticalAlignment: KernLabelVerticalAlignment = .Top) {
        self.attributedText = NSMutableAttributedString(attributedString: attributedText).kerning(with: kerningSettings)
        self.typesetter = CTTypesetterCreateWithAttributedString(self.attributedText)
        self.font = self.attributedText.font
        self.fontSize = self.font.pointSize
        self.lineHeight = self.attributedText.lineHeight
        self.width = rect.size.width
        self.height = rect.size.height
        self.startPosition = CGPointMake(
            (options.contains(.UsesLineFragmentOrigin) ? rect.origin.x : 0),
            (options.contains(.UsesLineFragmentOrigin) ? rect.origin.y : 0))
        self.currentPosition = CGPointZero
        self.truncateRect = NSString(string: truncateText).boundingRectWithSize(CGSizeMake(kCGFloatHuge, kCGFloatHuge), options: NSStringDrawingOptions(), attributes: attributedText.attributes, context: nil)
        self.lines = 0
        self.location = 0
        self.length = self.attributedText.length
        self.options = options
        self.truncateText = truncateText
        self.numberOfLines = numberOfLines
        self.verticalAlignment = verticalAlignment
        self.padding = padding
    }

    /**
     context を生成する。与えられた context が nil でないときはそのままそれを返す

     - parameter context: 描画する context
     - returns: 生成した context
     */
    private func createContext(context: CGContext? = nil) -> CGContext {
        if let context = context {
            return context
        }
        let contextWidth = Int((self.startPosition.x + self.width + self.padding.left + self.padding.right) * kScreenScale)
        let contextHeight = Int((self.startPosition.y + self.height + self.padding.top + self.padding.bottom) * kScreenScale)
        let c = CGBitmapContextCreate(
            nil, contextWidth, contextHeight, 8, 0, kCGColorSpace, kCGImageAlphaInfo)!
        CGContextTranslateCTM(c, 0, CGFloat(contextHeight))
        CGContextScaleCTM(c, kScreenScale, 0 - kScreenScale)
        return c
    }

    /**
     y の開始位置を移動
     一行目であれば、ascender 分だけを加算する（lineHeight だと descender も含まれるので上が不自然に開いてしまうので）
     */
    private mutating func goToNextLinePosition() {
        self.currentPosition.y += (self.lines == 0) ? self.font.ascender : self.lineHeight
    }

    /**
     行頭の文字を取得
     */
    private func getLineHead() -> String {
        return self.attributedText.substring(NSMakeRange(self.location, 1))
    }

    /**
     行末の文字を取得する。行末が改行の場合は、改行文字の前の文字を取得する。

     - parameter range: 行末の文字を取得するための、現在行の全体における範囲。
     - returns: 行末の文字
     */
    private func getLineTail(range: NSRange) -> String {
        var tail = ""
        let location = range.location + range.length
        if location <= self.attributedText.length {
            tail = self.attributedText.substring(NSMakeRange(location - 1, 1))
            if tail == "\n" && location - 2 >= 0 {  // 行末が改行の場合は、改行文字の前の文字を取得する。
                tail = self.attributedText.substring(NSMakeRange(location - 2, 1))
            }
        }
        return tail
    }

    /**
     行頭オフセットを取得。カーニング対象文字の場合は、半角分のオフセット

     - parameter lineHead: 行頭文字
     */
    private func getOffset(lineHead: String? = nil) -> CGFloat {
        return kCharactersHaveLeftSpace.contains(lineHead ?? self.getLineHead()) ? self.fontHalfWidth : 0
    }

    /**
     行末から offset を計算する

     - parameter range: offset を計算するための、現在行の全体における範囲
     - returns: 行末文字と alignment を考慮した際の行頭オフセット
     */
    private func getOffsetTail(with offsetHead: CGFloat, range: NSRange) -> CGFloat {
        guard let alignment = self.attributedText.textAlignment else {
            return 0
        }
        let tail = self.getLineTail(range)
        var offset: CGFloat = 0
        switch alignment {
        case .Right:
            offset -=
                (
                    (kCharactersHaveRightSpace.contains(tail) ? self.fontHalfWidth : 0) +
                        (self.width - self.attributedText.attributedSubstringFromRange(range).boundingRect(
                        options: [.UsesLineFragmentOrigin], context: nil).size.width) + offsetHead
                )
        case .Center:
            offset -=
                (
                    (kCharactersHaveRightSpace.contains(tail) ? self.fontHalfWidth : 0) +
                    (self.width - self.attributedText.attributedSubstringFromRange(range).boundingRect(
                        options: [.UsesLineFragmentOrigin], context: nil).size.width) + offsetHead
                ) / 2
        default:
            break  // .Left, .Justified
        }
        return offset
    }

    /**
     offset を考慮したうえで、現在の行には何文字入るか？

     - parameter offset: 行頭オフセット。指定しない場合は `getOffset()` で算出したものを使用する
     - returns: (現在行にはいる文字数, ぶらさがるかどうか)
     */
    private func getSuggestedLineCount(offset: CGFloat? = nil) -> (Int, Bool, Bool) {
        let lineWidth: CGFloat = self.width + (offset ?? self.getOffset())
        var currentLineCount = CTTypesetterSuggestLineBreak(self.typesetter, self.location, Double(lineWidth))
        var range = self.getCurrentLineRange(currentLineCount)
        var (didBurasagari, didOikomi) = (false, false)

        if let alignment = self.attributedText.textAlignment where alignment == .Justified {
            if range.location + range.length + 2 <= self.length {  // 1文字加算しても全体の文字数に収まるか
                let tmpTail = self.attributedText.substring(NSMakeRange(range.location + range.length + 1, 1))  // 次の行の2文字目
                if kCharactersCanBurasagari.contains(tmpTail) {
                    range = NSMakeRange(range.location, range.length + 2)
                    currentLineCount = range.length
                    didBurasagari = true
                } else if kCharactersCanOikomi.contains(tmpTail) {
                    range = NSMakeRange(range.location, range.length + 2)
                    currentLineCount = range.length
                    didOikomi = true
                }
            }
        }
        return (currentLineCount, didBurasagari, didOikomi)
    }

    /**
     現在行の、全体におけるレンジ

     - returns: 全体における現在行の範囲
     */
    private func getCurrentLineRange(currentLineCount: Int? = nil) -> NSRange {
        return NSMakeRange(
            self.location,
            currentLineCount ?? self.getSuggestedLineCount(self.getOffset()).0)
    }

    /** 
     次の行が指定した高さを超えるか or 行数制限を超えるか

     - returns: 次の行が指定した高さを超えるか or 行数制限を超えるか
     */
    private func isOverflow(currentLineCount: Int? = nil) -> Bool {
        let surplus = self.location + (currentLineCount ?? self.getSuggestedLineCount().0) < self.length
        let heightShortage = self.currentPosition.y + self.lineHeight > self.height
        let exceedNumberOfLines = self.numberOfLines == 0 ? false : self.lines + 1 >= self.numberOfLines
        return exceedNumberOfLines || (surplus && heightShortage)
    }

    /**
     truncate する行の文字数 (truncate 文字列を含まない)

     - parameter: 行頭オフセット
     - returns: truncate される行の挿入可能な文字数 (truncate 文字分の幅を含めない)
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

    /**
     range 行を、context 上に描画する。また、描画した行の実質的な幅をかえす。

     - parameters:
        - range: 全体における描画する行の範囲
        - offset: 行頭オフセット
        - burasagari: ぶらさがりするか？
        - on: 描画する context
     - returns: (描画する行の実質的な幅(長さ), xオフセット, yオフセット, ctline)
     */
    private func getCTLine(range: NSRange, offset: CGFloat, burasagari: Bool = false, oikomi: Bool = false) -> (CGFloat, CGFloat, CGFloat, CTLine) {

        // 描画開始位置を設定。offsetで行頭約物の位置を修正
        let offsetX = self.startPosition.x + self.currentPosition.x + self.padding.left - offset
        let offsetY = self.startPosition.y + self.currentPosition.y + self.padding.top

        // 行を生成
        var ctline = CTTypesetterCreateLine(
            self.typesetter, CFRangeMake(range.location, range.length))

        // 実質の文字の幅を取得
        let typographicWidth = CTLineGetTypographicBounds(ctline, nil, nil, nil)

        // 均等揃えする。ぶら下がりのために、右側のスペースを開けておく
        if let alignment = self.attributedText.textAlignment where alignment == .Justified {
            let burasagariSpace = burasagari ? Double(self.fontSize) : 0
            let oikomiSpace = oikomi ? Double(self.fontSize / 2) : 0
            let lineWidth = Double(self.width) + burasagariSpace + oikomiSpace
            if typographicWidth > (lineWidth - Double(self.fontSize)) {
                if let justifiedCtline = CTLineCreateJustifiedLine(ctline, 1, lineWidth) {
                    ctline = justifiedCtline
                }
            }
        }
        return (CGFloat(typographicWidth), offsetX, offsetY, ctline)
    }

    private func fillBackgroundColor(rect: CGRect, on context: CGContext?) {
        guard let context = context else {
            return
        }
        guard let backgroundColor = self.attributedText.backgroundColor else {
            return
        }
        backgroundColor.setFill()
        CGContextFillRect(context, rect)
    }

    /**
     与えられた全ての行を描画する

     - parameters
        - lines: (typographicWidth, offsetX, offsetY, ctline)
        - context: 描画する context. 与えないとスキップする
     */
    private func drawLines(lines: [(CGFloat, CGFloat, CGFloat, CTLine)], on context: CGContext?) {
        guard let context = context else {
            return
        }
        let y = self.getDrawOffsetY()
        self.fillBackgroundColor(
            CGRectMake(
                self.startPosition.x, self.startPosition.y + y,
                self.intrinsicTextSize.width + self.padding.left + self.padding.right,
                self.intrinsicTextSize.height + self.padding.top + self.padding.bottom
            ),
            on: context)
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1)) // 反転を戻す
        lines.forEach { _, offsetX, offsetY, ctline in
            CGContextSetTextPosition(context, offsetX, offsetY + y)
            CTLineDraw(ctline, context)
        }
    }

    /**
     次の行に進む

     - parameter: 現在行の文字数 (これを `location` に加えて次の行に進む)
     */
    private mutating func goToNextLine(count: Int) {
        self.location += count
        self.lines += 1
    }

    /**
     `verticalAlignment` で設定した値をもとに Y 座標のオフセットを返す

     - returns: 描画する行の Y 座標のオフセット
     - precondition: `instrinsicTextSize` が計算済みであること
     */
    private func getDrawOffsetY() -> CGFloat {
        switch self.verticalAlignment {
        case .Top:
            return 0
        case .Middle:    // ↓ Int で切り捨ててピクセルまたぎでボヤけないようにする
            return CGFloat(Int((self.height - self.intrinsicTextSize.height) / 2))
        case .Bottom:
            return CGFloat(Int(self.height - self.intrinsicTextSize.height))
        }
    }

    /**
     文字を生成する。canvasContext を与えると、そこに文字を描画する。
     needsDrawing を false にすると、実際に描画しない（カーニングや禁則を処理し、描画はせず描画領域 (intrinsicTextSize) をセットして終了する）

     - parameter canvasContext: 文字が描画される context
     - parameter needsDrawing: 描画をするかどうか
     - returns: 描画された context
     */
    private mutating func process(canvasContext: CGContext? = nil, needsDrawing: Bool = true) -> CGContext? {

        if self.attributedText.string.isEmpty {
            return nil
        }

        let context: CGContext? = needsDrawing ? self.createContext(canvasContext) : nil

        /// currentLongestTypographicWidth, offsetX, offsetY, ctline
        var lines: [(CGFloat, CGFloat, CGFloat, CTLine)] = []

        while self.location < self.length {

            self.goToNextLinePosition()
            var offset = self.getOffset()
            let (currentLineCount, burasagari, oikomi) = self.getSuggestedLineCount(offset)
            var range = self.getCurrentLineRange(currentLineCount)

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
            offset += self.getOffsetTail(with: offset, range: range)

            lines.append(self.getCTLine(range, offset: offset, burasagari: burasagari, oikomi: oikomi))

            // 次の行が指定した高さを超える場合は終了
            if overflow {
                break
            }

            // 次の行へ
            self.goToNextLine(currentLineCount)
        }

        // 文字の大きさを補足
        self.intrinsicTextSize = CGSizeMake(
            lines.maxElement { $0.0 < $1.0 }?.0 ?? self.width,  // 最も大きい typographicWidth
            CGFloat(Int(self.currentPosition.y + self.font.ascender - self.font.capHeight)))

        // 全ての行を描画
        self.drawLines(lines, on: context)

        return context
    }

    /**
     文字を context に描画する

     - parameter on: 文字が描画される context
     */
    mutating func drawText(on context: CGContext) {
        self.process(context)
    }

    /**
     文字が描画された CGImage をかえす
     */
    mutating func createImage() -> CGImage? {
        guard let typedContext = self.process() else {
            return nil
        }
        CGContextTranslateCTM(typedContext, 0, self.height)
        return CGBitmapContextCreateImage(typedContext)
    }

    /**
     文字を処理して描画範囲 (intrinsicTextSize) をセットする。 context への描画は行わない

     - seealso: `process(:_, needsDrawing:_)`
     */
    mutating func processWithoutDrawing() {
        self.process(nil, needsDrawing: false)
    }
}
