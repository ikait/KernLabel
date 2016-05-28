//
//  KernLabel.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/05/24.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


final class DefaultLabelSettings {
    static let font = UIFont.systemFontOfSize(17)
    static let textColor = UIColor.blackColor()
    static let textAlignment = NSTextAlignment.Left
    static let lineBreakMode = NSLineBreakMode.ByTruncatingTail
    static let enabled = true
    static let adjustsFontSizeToFitWidth = false
    static let allowsDefaultTighteningForTruncation = false
    static let baselineAdjustment = UIBaselineAdjustment.AlignBaselines
    static let minimumScaleFactor: CGFloat = 0
    static let numberOfLines: Int = 0
    static let highlightedTextColor: UIColor? = nil
    static let highlighted = false
    static let shadowColor: UIColor? = nil
    static let shadowOffset = CGSizeMake(0, -1)
    static let preferredMaxLayoutWidth: CGFloat = 0
    static let truncateText = "..."
}


/**
 カーニングされたテキストを表示するクラス

 [UILabel Class Reference - Apple Developer]: https://developer.apple.com/library/ios/documentation/UIKit/Reference/UILabel_Class/#//apple_ref/occ/instp/UILabel "UILabel Class Reference - Apple Developer"
 - seealso: [UILabel Class Reference - Apple Developer]
 */
public class KernLabel: UIView {


    // MARK: - Accessing the Text Attributes

    /**
     The text displayed by the label.
     */
    public var text: String? {
        get {
            return self.attributedText?.string
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.attributedText = NSAttributedString(string: newValue, attributes: [
                NSFontAttributeName: DefaultLabelSettings.font,
                NSForegroundColorAttributeName: DefaultLabelSettings.textColor
            ])
        }
    }

    /**
     The styled text displayed by the label.
     */
    public var attributedText: NSAttributedString? = nil {
        didSet {
            self.setNeedsDisplayInRect(self.bounds)
            self.setNeedsUpdateConstraints()
        }
    }

    /**
     The font of the text.
     */
    public var font: UIFont {
        get {
            if let attributedText = self.attributedText,
                let attributes = attributedText.attributes,
                let font = attributes[NSFontAttributeName] as? UIFont {
                return font
            }
            return self._font
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                attributedText.attributes = [
                    NSFontAttributeName: newValue
                ]
                self.attributedText = attributedText
            }
            self._font = newValue
        }
    }
    var _font = DefaultLabelSettings.font


    /**
     The color of the text.
     */
    public var textColor: UIColor {
        get {
            if let attributedText = self.attributedText,
                let attributes = attributedText.attributes,
                let color = attributes[NSForegroundColorAttributeName] as? UIColor {
                return color
            }
            return self._textColor
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                attributedText.attributes = [
                    NSForegroundColorAttributeName: newValue
                ]
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
    public var textAlignment: NSTextAlignment {
        get {
            if let attributedText = self.attributedText,
                let attributes = attributedText.attributes,
                let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
                return paragraphStyle.alignment
            }
            return self._textAlignment
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = newValue
                attributedText.attributes = [
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
                self.attributedText = attributedText
            }
            self._textAlignment = newValue
        }
    }
    var _textAlignment = DefaultLabelSettings.textAlignment


    /**
     The technique to use for wrapping and truncating the label’s text.

     - seealso: adjustsFontSizeToFitWidth
     */
    public var lineBreakMode: NSLineBreakMode {
        get {
            if let attributedText = self.attributedText,
                let attributes = attributedText.attributes,
                let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
                return paragraphStyle.lineBreakMode
            }
            return self._lineBreakMode
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = newValue
                attributedText.attributes = [
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
                self.attributedText = attributedText
            }
            self._lineBreakMode = newValue
        }
    }
    var _lineBreakMode = DefaultLabelSettings.lineBreakMode


    /**
     The enabled state to use when drawing the label’s text.
     */
    public var enabled = DefaultLabelSettings.enabled


    // MARK: - Sizing

    @available(iOS 9.0, *)
    public var allowsDefaultTighteningForTruncation: Bool {
        get {
            if let attributedText = self.attributedText,
                let attributes = attributedText.attributes,
                let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle {
                return paragraphStyle.allowsDefaultTighteningForTruncation
            }
            return self._allowsDefaultTighteningForTruncation
        }
        set {
            if let _attributedText = self.attributedText {
                let attributedText = NSMutableAttributedString(attributedString: _attributedText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.allowsDefaultTighteningForTruncation = newValue
                attributedText.attributes = [
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
                self.attributedText = attributedText
            }
            self._allowsDefaultTighteningForTruncation = newValue
        }
    }
    var _allowsDefaultTighteningForTruncation = DefaultLabelSettings.allowsDefaultTighteningForTruncation

    public var adjustsFontSizeToFitWidth = DefaultLabelSettings.adjustsFontSizeToFitWidth
    public var baselineAdjustment = DefaultLabelSettings.baselineAdjustment
    public var minimumScaleFactor: CGFloat = DefaultLabelSettings.minimumScaleFactor
    public var numberOfLines: Int = DefaultLabelSettings.numberOfLines


    // MARK: - Managing Highlight Values

    public var highlightedTextColor: UIColor? = DefaultLabelSettings.highlightedTextColor
    public var highlighted = DefaultLabelSettings.highlighted


    // MARK: - Drawing a Shadow

    public var shadowColor: UIColor? = DefaultLabelSettings.shadowColor
    public var shadowOffset = DefaultLabelSettings.shadowOffset
    public var preferredMaxLayoutWidth: CGFloat = DefaultLabelSettings.preferredMaxLayoutWidth
    public var truncateText = DefaultLabelSettings.truncateText

    // MARK: - Methods

    /**
     Text rect size
     */
    public func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let _attributedText = self.attributedText else {
            return CGRectZero
        }
        var type = Type(
            attributedText: _attributedText,
            rect: bounds,
            numberOfLines: self.numberOfLines,
            options: [.UsesLineFragmentOrigin],
            truncateText: self.truncateText)
        type.createDrawedImage()
        return CGRect(origin: CGPointZero, size: type.intrinsicTextSize!)
    }

    /**
     Label size amount of texts considered
     */
    public override func intrinsicContentSize() -> CGSize {
        guard self.attributedText != nil else {
            return CGSizeZero
        }
        let width = self.preferredMaxLayoutWidth == 0 ?
            (superview?.frame.width ?? kCGFloatHuge) : self.preferredMaxLayoutWidth
        let rect = CGRectMake(0, 0, width, kCGFloatHuge)
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

    private func initLabelSettings() {
        self.contentMode = .Redraw
        self.backgroundColor = UIColor.clearColor()
    }

    public override func updateConstraints() {
        self.invalidateIntrinsicContentSize()
        if self.preferredMaxLayoutWidth != self.bounds.width {
            self.preferredMaxLayoutWidth = self.bounds.width
        }
        super.updateConstraints()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplayInRect(self.bounds)
        self.setNeedsUpdateConstraints()
    }

    private func drawRectWithKerning(rect: CGRect, options: NSStringDrawingOptions, context: CGContextRef) {
        guard let _attributedText = self.attributedText else {
            return
        }
        var type = Type(
            attributedText: _attributedText,
            rect: rect,
            numberOfLines: self.numberOfLines,
            options: options,
            truncateText: self.truncateText)
        type.drawText(on: context)
    }

    public func drawTextInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        var options = NSStringDrawingOptions.UsesLineFragmentOrigin
        if self.lineBreakMode == .ByTruncatingTail {
            options.unionInPlace(.TruncatesLastVisibleLine)
        }
        self.drawRectWithKerning(
            rect,
            options: options,
            context: context!)
    }

    public override func drawRect(rect: CGRect) {
        self.drawTextInRect(rect)
    }
}
