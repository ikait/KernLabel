//
//  KernTypeString.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/06/01.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


open class KernTypeString {

    open var string: String = ""
    open var attributes: [NSAttributedStringKey : Any] = [:]
    open var kerningMode: KernLabelKerningMode = .normal

    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self.string)
        return attributedString
    }

    public init(string: String) {
        self.string = string
    }

    public init(string: String, attributes: [NSAttributedStringKey : Any]) {
        self.string = string
        self.attributes = attributes
    }
    
    public init() {
    }

    open func boundingHeight(_ width: CGFloat, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRectWithSize(CGSize(width: width, height: kCGFloatHuge), options: options, numberOfLines: numberOfLines, context: context).size.height
    }

    open func boundingWidth(_ height: CGFloat, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRectWithSize(CGSize(width: kCGFloatHuge, height: height), options: options, numberOfLines: numberOfLines, context: context).size.width
    }

    open func boundingRectWithSize(_ size: CGSize, options: NSStringDrawingOptions, numberOfLines: Int, context: NSStringDrawingContext?) -> CGRect {
        var type = Type(attributedText: self.attributedString, rect: CGRect(origin: CGPoint.zero, size: size), kerningSettings: self.kerningMode.kerningSettings, numberOfLines: 0, options: options, truncateText: DefaultLabelSettings.truncateText, verticalAlignment: .top)
        type.processWithoutDrawing()
        return CGRect(origin: CGPoint.zero, size: type.intrinsicTextSize)
    }

    open func size() -> CGSize {
        return self.boundingRectWithSize(CGSize(width: kCGFloatHuge, height: kCGFloatHuge), options: [], numberOfLines: 0, context: nil).size
    }

    open func drawWithRect(_ rect: CGRect, options: NSStringDrawingOptions, context: CGContext?, padding: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let context = context else {
            return
        }
        var type = Type(attributedText: self.attributedString, rect: rect, kerningSettings: self.kerningMode.kerningSettings, numberOfLines: 0, options: options)
        type.padding = padding
        type.drawText(on: context)
    }

    open func createImage(_ rect: CGRect, options: NSStringDrawingOptions) -> CGImage? {
        var type = Type(attributedText: self.attributedString, rect: rect, kerningSettings: self.kerningMode.kerningSettings, numberOfLines: 0, options: options)
        return type.createImage()
    }
}
