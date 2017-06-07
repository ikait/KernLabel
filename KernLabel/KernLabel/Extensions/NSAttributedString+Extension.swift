//
//  NSAttributedString+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


extension NSAttributedString {
    var lineHeight: CGFloat {
        guard let paragraphStyle = self.attributes[.paragraphStyle] as? NSParagraphStyle else {
                return self.font.lineHeight
        }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return self.font.lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }

    var textAlignment: NSTextAlignment? {
        guard let paragraphStyle = self.attributes[.paragraphStyle] as? NSParagraphStyle else {
            return nil
        }
        return paragraphStyle.alignment
    }

    var backgroundColor: UIColor? {
        return self.attributes[.backgroundColor] as? UIColor
    }

    var attributes: [NSAttributedStringKey : Any] {
        if self.length != 0 {
            return self.attributes(at: 0, effectiveRange: nil)
        } else {
            return [:]
        }
    }

    var font: UIFont {
        if let font = self.attributes[.font] as? UIFont {
            return font
        }
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    func substring(_ range: NSRange) -> String {
        return self.attributedSubstring(from: range).string
    }

    func substring(_ location: Int, _ length: Int) -> String {
        return self.substring(NSMakeRange(location, length))
    }

    func getFont(_ location: Int) -> UIFont? {
        if let font = self.attributes(at: location, effectiveRange: nil)[.font] as? UIFont {
            return font
        }
        return nil
    }

    func getLineHeight(_ location: Int) -> CGFloat {
        guard let paragraphStyle = self.attributes(at: location, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle, let font = self.getFont(location) else {
                return self.font.lineHeight
        }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return font.lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }

    func getTextAlignment(_ location: Int) -> NSTextAlignment? {
        guard let paragraphStyle = self.attributes(at: location, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle else {
            return nil
        }
        return paragraphStyle.alignment
    }

    func mutableAttributedString(from range: NSRange) -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self.attributedSubstring(from: range))
    }

    func boundingWidth(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRect(options: options, context: context).size.width
    }

    func boundingRect(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
        return self.boundingRect(with: CGSize(width: kCGFloatHuge, height: kCGFloatHuge), options: options, context: context)
    }

    func boundingRectWithSize(_ size: CGSize, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGRect {
        let boundingRect = self.boundingRect(
            with: CGSize(width: size.width, height: self.lineHeight * CGFloat(numberOfLines)), options: options, context: context)
        return boundingRect
    }
}
