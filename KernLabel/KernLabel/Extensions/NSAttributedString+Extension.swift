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
        guard let attributes = self.attributes,
            let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
                return self.font.lineHeight
        }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return self.font.lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }

    var textAlignment: NSTextAlignment? {
        guard let attributes = self.attributes,
            let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            return nil
        }
        return paragraphStyle.alignment
    }

    var attributes: [String : AnyObject]? {
        return self.length != 0 ? self.attributesAtIndex(0, effectiveRange: nil) : nil
    }

    var font: UIFont {
        if let attributes = self.attributes, font = attributes[NSFontAttributeName] as? UIFont {
            return font
        }
        return UIFont.systemFontOfSize(UIFont.systemFontSize())
    }

    func boundingWidth(options options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRect(options: options, context: context).size.width
    }

    func boundingRect(options options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
        return self.boundingRectWithSize(CGSizeMake(kCGFloatHuge, kCGFloatHuge), options: options, context: context)
    }

    func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGRect {
        let boundingRect = self.boundingRectWithSize(
            CGSizeMake(size.width, self.lineHeight * CGFloat(numberOfLines)), options: options, context: context)
        return boundingRect
    }
}