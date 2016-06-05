//
//  NSMutableAttributedString+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


extension NSMutableAttributedString {
    func kerning(regexp: NSRegularExpression?) -> Self {
        guard let regexp = regexp else {
            return self
        }
        let defaultFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        regexp.matchesInString(self.string, options: [], range: NSMakeRange(0, self.length)).enumerate().forEach { result in
            let (location, length) = (result.element.range.location, result.element.range.length)
            let curAttrs = self.attributesAtIndex(location, effectiveRange: nil)
            let font = curAttrs[NSFontAttributeName] as? UIFont ?? defaultFont
            self.addAttribute(NSKernAttributeName, value: font.pointSize * -0.5, range: NSMakeRange(location, length - 1))
        }
        return self
    }

    override var attributes: [String : AnyObject]? {
        get {
            return super.attributes
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.addAttributes(newValue, range: NSMakeRange(0, self.length))
        }
    }
}
