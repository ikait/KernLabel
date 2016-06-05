//
//  KernTypeString.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/06/01.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


public class KernTypeString {

    public var string: String = ""
    public var attributes: [String : AnyObject]? = [:]
    public var padding: UIEdgeInsets = UIEdgeInsetsZero

    var attributedString: NSAttributedString {
        return NSAttributedString(string: self.string, attributes: self.attributes)
    }

    public init(string: String) {
        self.string = string
    }

    public init(string: String, attributes: [String: AnyObject]?) {
        self.string = string
        self.attributes = attributes
    }
    
    public init() {
    }

    public func boundingHeight(width: CGFloat, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRectWithSize(CGSizeMake(width, kCGFloatHuge), options: options, numberOfLines: numberOfLines, context: context).size.height
    }

    public func boundingWidth(height: CGFloat, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRectWithSize(CGSizeMake(kCGFloatHuge, height), options: options, numberOfLines: numberOfLines, context: context).size.width
    }

    public func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGRect {
        var type = Type(attributedText: self.attributedString, rect: CGRect(origin: CGPointZero, size: size), kerningRegexp: KernLabelKerningMode.Normal.regexp, numberOfLines: 10, options: options)
        type.createImage()
        return CGRect(origin: CGPointZero, size: type.intrinsicTextSize)
    }

    public func size() -> CGSize {
        return self.boundingRectWithSize(CGSizeMake(kCGFloatHuge, kCGFloatHuge), options: [], numberOfLines: 0, context: nil).size
    }

    public func drawWithRect(rect: CGRect, options: NSStringDrawingOptions, context: CGContextRef?) {
        guard let context = context else {
            return
        }
        var type = Type(attributedText: self.attributedString, rect: rect, kerningRegexp: KernLabelKerningMode.Normal.regexp, numberOfLines: 0, options: options)
        type.drawText(on: context)
    }

    public func createImage(rect: CGRect, options: NSStringDrawingOptions) -> CGImage? {
        var type = Type(attributedText: self.attributedString, rect: rect, kerningRegexp: KernLabelKerningMode.Normal.regexp, numberOfLines: 0, options: options)
        return type.createImage()
    }
}
