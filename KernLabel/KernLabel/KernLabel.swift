//
//  KernLabel.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/05/24.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


final class DefaultLabelSettings {
    static let font = UIFont.systemFont(ofSize: 17)
    static let textColor = UIColor.black
    static let textAlignment = NSTextAlignment.left
    static let lineBreakMode = NSLineBreakMode.byTruncatingTail
    static let enabled = true
    static let adjustsFontSizeToFitWidth = false
    static let allowsDefaultTighteningForTruncation = false
    static let baselineAdjustment = UIBaselineAdjustment.alignBaselines
    static let minimumScaleFactor: CGFloat = 0
    static let numberOfLines: Int = 0
    static let highlightedTextColor: UIColor? = nil
    static let highlighted = false
    static let shadowColor: UIColor? = nil
    static let shadowOffset = CGSize(width: 0, height: -1)
    static let preferredMaxLayoutWidth: CGFloat = 0
    static let truncateText = "..."
    static let kerningMode = KernLabelKerningMode.normal
    static let verticalAlignment = KernLabelVerticalAlignment.middle
}


/**
 カーニングモードの設定
 */
public enum KernLabelKerningMode: Int {

    /// 行頭以外のカーニングを行わない
    case none

    /// 終わり括弧と始め括弧の間などの一部のみをカーニング
    case minimum

    /// 括弧全てをカーニング
    case normal

    /// 括弧全てと句読点をカーニング
    case all

    internal var kerningSettings: KerningSettings {
        switch self {
        case .none:
            return []
        case .minimum:
            return kKernLabelKerningSettingsMinimum
        case .normal:
            return kKernLabelKerningSettingsNormal
        case .all:
            return kKernLabelKerningSettingsAll
        }
    }
}


/**
 カーニングを行うための正規表現とカーニング値(フォントサイズを1としたときの比率)
 */
typealias KerningSettings = [(NSRegularExpression, CGFloat)]

let k句読点 = "、，。．"
let k括弧閉 = "｝］」』）｠〉》〕〙】〗"
let k括弧開 = "｛［「『（｟〈《〔〘【〖"
let k他約物 = "！？：；︰‐・…‥〜ー―※"
private let kKernLabelKerningSettingsMinimum: KerningSettings = [
    (try! NSRegularExpression(
        pattern: "([\(k括弧閉)\(k句読点)])\n" + "|" +
                 "([\(k括弧閉)\(k句読点)])$" + "|" +
                 "([\(k括弧閉)\(k句読点)][\(k他約物)]?)(?=[\(k括弧開)])",
        options: []), 0 - kCharacterHalfSpace)]
private let kKernLabelKerningSettingsNormal: KerningSettings = [
    (try! NSRegularExpression(
        pattern: "([\(k句読点)])\n" + "|" +
                 "([\(k句読点)])$" + "|" +
                 "([\(k括弧閉)])|(.)(?=[\(k括弧開)])",
        options: []), 0 - kCharacterHalfSpace),
    (try! NSRegularExpression(
        pattern: "([\(k括弧閉)])(?=[\(k括弧開)])", options: []), -1)
]
private let kKernLabelKerningSettingsAll: KerningSettings = [
    (try! NSRegularExpression(
        pattern: "([\(k括弧閉)\(k句読点)])" + "|" +
                 "(.)(?=[\(k括弧開)])",
        options: []), 0 - kCharacterHalfSpace),
    (try! NSRegularExpression(
        pattern: "([\(k括弧閉)\(k句読点)])(?=[\(k括弧開)])", options: []), -1)
]


/**
 縦方向の位置
 */
public enum KernLabelVerticalAlignment: Int {
    case top
    case middle
    case bottom
}


/**
 カーニングされたテキストを表示するクラス

 [UILabel Class Reference - Apple Developer]: https://developer.apple.com/library/ios/documentation/UIKit/Reference/UILabel_Class/#//apple_ref/occ/instp/UILabel "UILabel Class Reference - Apple Developer"
 - seealso: [UILabel Class Reference - Apple Developer]
 */
open class KernLabel: UIView {


    // MARK: - Accessing the Text Attributes

    /**
     The text displayed by the label.
     */
    open var text: String? {
        get {
            return self.attributedText?.string
        }
        set {
            guard let newValue = newValue else {
                return
            }
            let style: NSParagraphStyle = {
                let style = NSMutableParagraphStyle()
                style.lineBreakMode = self.lineBreakMode
                style.alignment = self.textAlignment
                return style
            }()
            self.attributedText = NSAttributedString(string: newValue, attributes: [
                .font: self.font,
                .foregroundColor: self.textColor,
                .paragraphStyle: style
            ])
        }
    }

    /**
     The styled text displayed by the label.
     */
    open var attributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsDisplay(self.bounds)
            self.setNeedsUpdateConstraints()
        }
    }

    /**
     The font of the text.
     */
    open var font: UIFont {
        get {
            if let attributedText = self.attributedText,
                let font = attributedText.attributes[.font] as? UIFont {
                return font
            }
            return self._font
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                attributedText.setAttributes(attrs: [
                    .font: newValue
                ])
                self.attributedText = attributedText
            }
            self._font = newValue
        }
    }
    var _font = DefaultLabelSettings.font


    /**
     The color of the text.
     */
    open var textColor: UIColor {
        get {
            if let attributedText = self.attributedText,
                let color = attributedText.attributes[.foregroundColor] as? UIColor {
                return color
            }
            return self._textColor
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                attributedText.setAttributes(attrs: [
                    .foregroundColor: newValue
                ])
                self.attributedText = attributedText
            }
            self._textColor = newValue
        }
    }
    var _textColor = DefaultLabelSettings.textColor


    /**
     The technique to use for aligning the text. Supported alignments are as follows:

     * `.Left`
     * `.Center`
     * `.Right`
     */
    open var textAlignment: NSTextAlignment {
        get {
            if let attributedText = self.attributedText,
                let paragraphStyle = attributedText.attributes[.paragraphStyle] as? NSParagraphStyle {
                return paragraphStyle.alignment
            }
            return self._textAlignment
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = newValue
                paragraphStyle.lineBreakMode = self.lineBreakMode
                attributedText.setAttributes(attrs: [
                    .paragraphStyle: paragraphStyle
                ])
                self.attributedText = attributedText
            }
            self._textAlignment = newValue
        }
    }
    var _textAlignment = DefaultLabelSettings.textAlignment

    open var verticalAlignment = DefaultLabelSettings.verticalAlignment


    /**
     The technique to use for wrapping and truncating the label’s text.

     - seealso: adjustsFontSizeToFitWidth
     */
    open var lineBreakMode: NSLineBreakMode {
        get {
            if let attributedText = self.attributedText,
                let paragraphStyle = attributedText.attributes[.paragraphStyle] as? NSParagraphStyle {
                return paragraphStyle.lineBreakMode
            }
            return self._lineBreakMode
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = newValue
                paragraphStyle.alignment = self.textAlignment
                attributedText.setAttributes(attrs: [
                    .paragraphStyle: paragraphStyle
                ])
                self.attributedText = attributedText
            }
            self._lineBreakMode = newValue
        }
    }
    var _lineBreakMode = DefaultLabelSettings.lineBreakMode


    /**
     The enabled state to use when drawing the label’s text.
     */
    open var enabled = DefaultLabelSettings.enabled


    // MARK: - Sizing

    @available(iOS 9.0, *)
    open var allowsDefaultTighteningForTruncation: Bool {
        get {
            if let attributedText = self.attributedText,
                let paragraphStyle = attributedText.attributes[.paragraphStyle] as? NSParagraphStyle {
                return paragraphStyle.allowsDefaultTighteningForTruncation
            }
            return self._allowsDefaultTighteningForTruncation
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.allowsDefaultTighteningForTruncation = newValue
                attributedText.setAttributes(attrs: [
                    .paragraphStyle: paragraphStyle
                ])
                self.attributedText = attributedText
            }
            self._allowsDefaultTighteningForTruncation = newValue
        }
    }
    var _allowsDefaultTighteningForTruncation = DefaultLabelSettings.allowsDefaultTighteningForTruncation

    open var adjustsFontSizeToFitWidth = DefaultLabelSettings.adjustsFontSizeToFitWidth
    open var baselineAdjustment = DefaultLabelSettings.baselineAdjustment
    open var minimumScaleFactor: CGFloat = DefaultLabelSettings.minimumScaleFactor
    open var numberOfLines: Int = DefaultLabelSettings.numberOfLines
    open var kerningMode: KernLabelKerningMode = DefaultLabelSettings.kerningMode


    // MARK: - Managing Highlight Values

    open var highlightedTextColor: UIColor? = DefaultLabelSettings.highlightedTextColor
    open var highlighted = DefaultLabelSettings.highlighted


    // MARK: - Drawing a Shadow

    open var shadowColor: UIColor? = DefaultLabelSettings.shadowColor
    open var shadowOffset = DefaultLabelSettings.shadowOffset
    open var preferredMaxLayoutWidth: CGFloat = DefaultLabelSettings.preferredMaxLayoutWidth
    open var truncateText = DefaultLabelSettings.truncateText

    // MARK: - Methods

    /**
     Text rect size
     */
    open func textRectForBounds(_ bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let _attributedText = self.attributedText else {
            return CGRect.zero
        }
        var type = Type(
            attributedText: _attributedText,
            rect: bounds,
            kerningSettings: self.kerningMode.kerningSettings,
            numberOfLines: self.numberOfLines,
            options: [.usesLineFragmentOrigin],
            truncateText: self.truncateText)
        type.processWithoutDrawing()
        return CGRect(origin: CGPoint.zero, size: type.intrinsicTextSize)
    }

    /**
     Essential label size which amount of texts considered
     */
    open override var intrinsicContentSize : CGSize {
        return self.intrinsicContentSize(self.preferredMaxLayoutWidth == 0 ?
            (superview?.frame.width ?? kCGFloatHuge) : self.preferredMaxLayoutWidth)
    }

    /**
     Essential label size which amount of texts and width and height (optional) passed considered
     */
    open func intrinsicContentSize(_ width: CGFloat, height: CGFloat = kCGFloatHuge) -> CGSize {
        guard self.attributedText != nil else {
            return CGSize.zero
        }
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        return self.textRectForBounds(rect, limitedToNumberOfLines: 0).size
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLabelSettings()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initLabelSettings()
    }

    fileprivate func initLabelSettings() {
        self.contentMode = .redraw
        self.backgroundColor = UIColor.clear
    }

    open override func updateConstraints() {
        self.invalidateIntrinsicContentSize()
        if self.preferredMaxLayoutWidth != self.bounds.width {
            self.preferredMaxLayoutWidth = self.bounds.width
        }
        super.updateConstraints()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay(self.bounds)
        self.setNeedsUpdateConstraints()
    }

    fileprivate func drawRectWithKerning(_ rect: CGRect, options: NSStringDrawingOptions, context: CGContext) {
        guard let _attributedText = self.attributedText else {
            return
        }
        var type = Type(
            attributedText: _attributedText,
            rect: rect,
            kerningSettings: self.kerningMode.kerningSettings,
            numberOfLines: self.numberOfLines,
            options: options,
            truncateText: self.truncateText,
            verticalAlignment: self.verticalAlignment)
        type.drawText(on: context)
    }

    open func drawTextInRect(_ rect: CGRect, context: CGContext?) {
        guard let context = context else {
            return
        }
        var options = NSStringDrawingOptions.usesLineFragmentOrigin
        if self.lineBreakMode == .byTruncatingTail {
            options.formUnion(.truncatesLastVisibleLine)
        }
        self.drawRectWithKerning(
            rect,
            options: options,
            context: context)
    }

    open override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        self.drawTextInRect(rect, context: context)
    }
}
