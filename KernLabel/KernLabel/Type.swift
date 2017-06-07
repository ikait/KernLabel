//
//  Type.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


private let kScreenScale = UIScreen.main.scale
private let kCGColorSpace = CGColorSpaceCreateDeviceRGB()
private let kCGImageAlphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
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
let kCharacterHalfSpace: CGFloat = 0.5  // 右半分が空白な文字の、fontSize における実質的な幅の割合
public let kCGFloatHuge: CGFloat = pow(2, 12)


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
    var intrinsicTextSize = CGSize.zero

    /// フォントの半分の大きさ
    var fontHalfWidth: CGFloat {
        return self.fontSize / 2
    }

    var padding: UIEdgeInsets = UIEdgeInsets.zero

    var verticalAlignment = KernLabelVerticalAlignment.middle

    var kerningSettings = KernLabelKerningMode.normal.kerningSettings

    var backgroundColor: UIColor? = nil

    init(
        attributedText: NSAttributedString,
        rect: CGRect,
        kerningSettings: KerningSettings = KernLabelKerningMode.normal.kerningSettings,
        numberOfLines: Int = 0,
        options: NSStringDrawingOptions = .usesLineFragmentOrigin,
        padding: UIEdgeInsets = UIEdgeInsets.zero,
        truncateText: String = "...",
        verticalAlignment: KernLabelVerticalAlignment = .top) {
        self.attributedText = NSMutableAttributedString(attributedString: attributedText).kerning(with: kerningSettings)

        // Xcode8 + iOS 10 で、backgroundColor が意図しない形で drawLine に乗ってくるので、attributedText からは外しておく
        self.backgroundColor = self.attributedText.backgroundColor
        self.attributedText.removeAttribute(.backgroundColor, range: NSMakeRange(0, self.attributedText.length))

        self.typesetter = CTTypesetterCreateWithAttributedString(self.attributedText)
        self.font = self.attributedText.font
        self.fontSize = self.font.pointSize
        self.lineHeight = self.attributedText.lineHeight
        self.width = rect.size.width
        self.height = rect.size.height
        self.startPosition = CGPoint(
            x: (options.contains(.usesLineFragmentOrigin) ? rect.origin.x : 0),
            y: (options.contains(.usesLineFragmentOrigin) ? rect.origin.y : 0))
        self.currentPosition = CGPoint.zero
        self.truncateRect = NSString(string: truncateText).boundingRect(with: CGSize(width: kCGFloatHuge, height: kCGFloatHuge), options: NSStringDrawingOptions(), attributes: attributedText.attributes, context: nil)
        self.lines = 0
        self.location = 0
        self.length = self.attributedText.length
        self.options = options
        self.truncateText = truncateText
        self.numberOfLines = numberOfLines
        self.verticalAlignment = verticalAlignment
        self.kerningSettings = kerningSettings
        self.padding = padding
    }

    /**
     context を生成する。与えられた context が nil でないときはそのままそれを返す

     - parameter context: 描画する context
     - returns: 生成した context
     */
    fileprivate func createContext(_ context: CGContext? = nil) -> CGContext {
        if let context = context {
            return context
        }
        let contextWidth = Int((self.startPosition.x + self.width + self.padding.left + self.padding.right) * kScreenScale)
        let contextHeight = Int((self.startPosition.y + self.height + self.padding.top + self.padding.bottom) * kScreenScale)
        let c = CGContext(
            data: nil, width: contextWidth, height: contextHeight, bitsPerComponent: 8, bytesPerRow: 0, space: kCGColorSpace, bitmapInfo: kCGImageAlphaInfo)!
        c.translateBy(x: 0, y: CGFloat(contextHeight))
        c.scaleBy(x: kScreenScale, y: 0 - kScreenScale)
        return c
    }

    /**
     y の開始位置を移動
     一行目であれば、ascender 分だけを加算する（lineHeight だと descender も含まれるので上が不自然に開いてしまうので）
     */
    fileprivate mutating func goToNextLinePosition() {
        self.currentPosition.y += (self.lines == 0) ? self.font.ascender : self.lineHeight
    }

    /**
     行頭の文字を取得
     */
    fileprivate func getLineHead() -> String {
        return self.attributedText.substring(self.location, 1)
    }

    /**
     行末の文字を取得する。行末が改行の場合は、改行文字の前の文字を取得する。

     - parameter range: 行末の文字を取得するための、現在行の全体における範囲。
     - returns: (行末の文字, 行末が改行か)
     */
    fileprivate func getLineTail(_ range: NSRange) -> (String, Bool) {
        var (tail, returned) = ("", false)
        let location = range.location + range.length
        if location <= self.attributedText.length {
            tail = self.attributedText.substring(location - 1, 1)
            if tail == "\n" && location - 2 >= 0 {  // 行末が改行の場合は、改行文字の前の文字を取得する。
                tail = self.attributedText.substring(location - 2, 1)
                returned = true
            }
        }
        return (tail, returned)
    }

    /**
     行頭オフセットを取得。カーニング対象文字の場合は、半角分のオフセット

     - parameter lineHead: 行頭文字
     */
    fileprivate func getHeadOffset(_ lineHead: String? = nil) -> CGFloat {
        return kCharactersHaveLeftSpace.contains(lineHead ?? self.getLineHead()) ? self.fontHalfWidth * -1 : 0
    }

    /**
     offset を考慮したうえで、現在の行には何文字入るか？

     - parameter offset: 行頭オフセット。指定しない場合は `getOffset()` で算出したものを使用する
     - returns: (現在行にはいる文字数, ぶらさがるかどうか)
     */
    fileprivate func getSuggestedLineCount(_ offset: CGFloat? = nil) -> Int {
        let lineWidth: CGFloat = self.width - (offset ?? self.getHeadOffset())
        return CTTypesetterSuggestLineBreak(self.typesetter, self.location, Double(lineWidth))
    }

    /**
     現在行の、全体におけるレンジ

     - returns: 全体における現在行の範囲
     */
    fileprivate func getCurrentLineRange(_ currentLineCount: Int? = nil) -> NSRange {
        return NSMakeRange(
            self.location,
            currentLineCount ?? self.getSuggestedLineCount(self.getHeadOffset()))
    }

    /** 
     次の行が指定した高さを超えるか or 行数制限を超えるか

     - returns: 次の行が指定した高さを超えるか or 行数制限を超えるか
     */
    fileprivate func isOverflow(_ currentLineCount: Int? = nil) -> Bool {
        let surplus = self.location + (currentLineCount ?? self.getSuggestedLineCount()) < self.length
        let heightShortage = self.currentPosition.y + self.lineHeight > self.height
        let exceedNumberOfLines = self.numberOfLines == 0 ? false : self.lines + 1 >= self.numberOfLines
        return exceedNumberOfLines || (surplus && heightShortage)
    }

    /**
     truncate する行の文字数 (truncate 文字列を含まない)

     - parameter: 行頭オフセット
     - returns: truncate される行の挿入可能な文字数 (truncate 文字分の幅を含めない)
     */
    fileprivate func getTruncateLineCount(_ offset: CGFloat? = nil) -> Int {
        return CTTypesetterSuggestLineBreak(
            self.typesetter,
            self.location,
            Double(self.width - (offset ?? self.getHeadOffset()) - self.truncateRect.size.width))
    }

    /**
     truncate がスタートする位置
     */
    fileprivate func getTruncateStartLocation(_ truncateLineCount: Int? = nil) -> Int {
        return (truncateLineCount ?? self.getTruncateLineCount()) + self.location
    }

    /**
     alignment を考慮せずに CTLine を取得する
     - parameter from: CTLine を取得する範囲
     - returns: CTLine, NSMutableAttributedString
     */
    fileprivate func getCTLine(from attributedText: NSMutableAttributedString, range: NSRange) -> (CTLine, NSMutableAttributedString) {
        var croppedAttributedText = attributedText.mutableAttributedString(from: range)
        let tailCharacter = croppedAttributedText.string.first
        if k他約物.contains(tailCharacter) {
            croppedAttributedText = croppedAttributedText.clearKerning(with: NSMakeRange(croppedAttributedText.length - 1, 1))
            return (CTLineCreateWithAttributedString(croppedAttributedText), croppedAttributedText)
        } else {
            return (CTTypesetterCreateLine(self.typesetter, CFRangeMake(range.location, range.length)), croppedAttributedText)
        }
    }

    /**
     CTLine から中央揃えされた CTLine を取得する
     - parameter from: ctline
     - parameter lineWidth: 行の長さ
     */
    fileprivate func getCTLineJustified(from ctline: CTLine, lineWidth: CGFloat) -> CTLine? {
        return CTLineCreateJustifiedLine(ctline, 1, Double(lineWidth))
    }

    /**
     range で指定した行の x, y オフセットと CTLine を生成する

     - parameters:
        - range: 全体における描画する行の範囲
        - headOffset: 行頭オフセット
     - returns: (描画する行の実質的な幅(長さ), xオフセット, yオフセット, ctline)
     */
    fileprivate func getLineSetting(_ range: NSRange, headOffset: CGFloat) -> (CGFloat, CGFloat, CGFloat, CTLine) {

        // 行を生成
        var (ctline, attributedText) = self.getCTLine(from: self.attributedText, range: range)

        // 実質の文字の幅を取得
        let alignment = attributedText.textAlignment ?? .left
        var lineWidth = self.width
        let lineBounds = CTLineGetBoundsWithOptions(ctline, [.useGlyphPathBounds]).integral
        let (realLineOffsetX, realLineWidth) = (lineBounds.origin.x, lineBounds.width)

        // 描画開始位置を設定。offsetで行頭約物の位置を修正
        let offsetX: CGFloat = {
            var x = self.startPosition.x + self.currentPosition.x + self.padding.left
            switch alignment {
                case .center: x += (self.width - realLineWidth) / 2 - realLineOffsetX
                case .right:  x += self.width - realLineWidth - realLineOffsetX
                case .justified:
                    x += headOffset == 0 ? 0 : -realLineOffsetX
                    lineWidth = lineWidth + realLineOffsetX
                    let kernValueSum = abs(attributedText.kerningValueSum(with: self.kerningSettings))
                    if realLineWidth + min(kernValueSum, self.fontSize) > (lineWidth - self.fontSize) {  // 残りの幅が fontSize 以下であれば justified しない
                        if let justifiedCtline = self.getCTLineJustified(from: ctline, lineWidth: lineWidth - realLineOffsetX) {
                            ctline = justifiedCtline
                        }
                    }
            default: x += headOffset == 0 ? 0 : -realLineOffsetX
            }
            return x
        }()
        let offsetY = self.startPosition.y + self.currentPosition.y + self.padding.top
        return (realLineWidth, offsetX, offsetY, ctline)
    }

    fileprivate func fillBackgroundColor(_ rect: CGRect, on context: CGContext?) {
        guard let context = context else {
            return
        }
        guard let backgroundColor = self.backgroundColor else {
            return
        }
        backgroundColor.setFill()
        context.fill(rect)
    }

    /**
     与えられた全ての行を描画する

     - parameters
        - lines: (typographicWidth, offsetX, offsetY, ctline)
        - context: 描画する context. 与えないとスキップする
     */
    fileprivate func drawLines(_ lines: [(CGFloat, CGFloat, CGFloat, CTLine)], on context: CGContext?) {
        guard let context = context else {
            return
        }
        let y = self.getDrawOffsetY()
        self.fillBackgroundColor(
            CGRect(
                x: self.startPosition.x, y: self.startPosition.y + y,
                width: self.intrinsicTextSize.width + self.padding.left + self.padding.right,
                height: self.intrinsicTextSize.height + self.padding.top + self.padding.bottom
            ),
            on: context)
        context.textMatrix = CGAffineTransform(scaleX: 1, y: -1) // 反転を戻す
        lines.forEach { (args) in
            let (_, offsetX, offsetY, ctline) = args
            context.textPosition = CGPoint(x: offsetX, y: offsetY + y)
            CTLineDraw(ctline, context)
        }
    }

    /**
     次の行に進む

     - parameter: 現在行の文字数 (これを `location` に加えて次の行に進む)
     */
    fileprivate mutating func goToNextLine(_ count: Int) {
        self.location += count
        self.lines += 1
    }

    /**
     `verticalAlignment` で設定した値をもとに Y 座標のオフセットを返す

     - returns: 描画する行の Y 座標のオフセット
     - precondition: `instrinsicTextSize` が計算済みであること
     */
    fileprivate func getDrawOffsetY() -> CGFloat {
        switch self.verticalAlignment {
        case .top:
            return 0
        case .middle:    // ↓ Int で切り捨ててピクセルまたぎでボヤけないようにする
            return CGFloat(Int((self.height - self.intrinsicTextSize.height) / 2))
        case .bottom:
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
    @discardableResult
    fileprivate mutating func process(_ canvasContext: CGContext? = nil, needsDrawing: Bool = true) -> CGContext? {

        if self.attributedText.string.isEmpty {
            return nil
        }

        let context: CGContext? = needsDrawing ? self.createContext(canvasContext) : nil

        /// typographicWidth, offsetX, offsetY, ctline
        var lines: [(CGFloat, CGFloat, CGFloat, CTLine)] = []

        while self.location < self.length {

            self.goToNextLinePosition()
            let offset = self.getHeadOffset()
            let currentLineCount = self.getSuggestedLineCount(offset)
            var range = self.getCurrentLineRange(currentLineCount)

            let overflow = self.isOverflow(currentLineCount)

            // overflow していて、 truncate する必要があるとき
            if overflow && self.options.contains(.truncatesLastVisibleLine) {
                let truncateLineCount = self.getTruncateLineCount(offset)
                let truncateStartLocation = self.getTruncateStartLocation(truncateLineCount)
                self.attributedText.deleteCharacters(
                    in: NSMakeRange(truncateStartLocation, self.attributedText.length - truncateStartLocation))
                self.attributedText.replaceCharacters(
                    in: NSMakeRange(truncateStartLocation, 0), with: self.truncateText)
                range = NSMakeRange(self.location, truncateLineCount + self.truncateText.length)
                self.typesetter = CTTypesetterCreateWithAttributedString(self.attributedText)
            }
            let (_, returned) = self.getLineTail(range)

            lines.append(self.getLineSetting(
                NSMakeRange(range.location, range.length - (returned ? 1 : 0)), headOffset: offset))

            // 次の行が指定した高さを超える場合は終了
            if overflow {
                break
            }

            // 次の行へ
            self.goToNextLine(currentLineCount)
        }

        // 文字の大きさを補足
        self.intrinsicTextSize = CGSize(
            width: lines.max { $0.0 < $1.0 }?.0 ?? self.width,  // 最も大きい typographicWidth
            height: CGFloat(Int(self.currentPosition.y + self.font.ascender - self.font.capHeight)))

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
        typedContext.translateBy(x: 0, y: self.height)
        return typedContext.makeImage()
    }

    /**
     文字を処理して描画範囲 (intrinsicTextSize) をセットする。 context への描画は行わない

     - seealso: `process(:_, needsDrawing:_)`
     */
    mutating func processWithoutDrawing() {
        self.process(nil, needsDrawing: false)
    }
}
