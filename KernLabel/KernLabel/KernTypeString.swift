//
//  KernTypeString.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/06/01.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


public class KernTypeString {

    public var string: String {
        get {
            return self.attributedString.string
        }
        set {
            self.attributedString = NSMutableAttributedString(string: newValue)
        }
    }

    public var attributedString = NSMutableAttributedString()

    public init(string: String) {
        self.string = string
    }

    public init(string: String, attributes: [String: AnyObject]?) {
        self.attributedString = NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    public init() {
    }

    public func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGRect {
        var type = Type(attributedText: self.attributedString, rect: CGRect(origin: CGPointZero, size: size), kerningRegexp: KernLabelKerningMode.Normal.regexp, numberOfLines: numberOfLines, options: options)
        type.createDrawedImage()
        return CGRect(origin: CGPointZero, size: type.intrinsicTextSize)
    }

    public func drawWithRect(rect: CGRect, options: NSStringDrawingOptions, context: CGContextRef?) {
        guard let context = context else {
            return
        }
        var type = Type(attributedText: self.attributedString, rect: rect, kerningRegexp: KernLabelKerningMode.Normal.regexp, numberOfLines: 0, options: options)
        type.drawText(on: context)
    }
}
