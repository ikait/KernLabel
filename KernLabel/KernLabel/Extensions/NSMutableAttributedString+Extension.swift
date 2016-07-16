//
//  NSMutableAttributedString+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


private let kDefaultFont = UIFont.systemFontOfSize(UIFont.systemFontSize())

extension NSMutableAttributedString {
    func kerning(regexp: NSRegularExpression, value: CGFloat = -0.5) -> Self {
        regexp.enumerateMatchesInString(self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, this = self else { return }
            let (location, length) = (result.range.location, result.range.length)
            let curAttrs = this.attributesAtIndex(location, effectiveRange: nil)
            let font = curAttrs[NSFontAttributeName] as? UIFont ?? kDefaultFont
            this.addAttribute(NSKernAttributeName, value: font.pointSize * value, range: NSMakeRange(location, length))
        }
        return self
    }

    func kerning(with settings: KerningSettings) -> Self {
        settings.forEach { (regexp, value) in
            self.kerning(regexp, value: value)
        }
        return self
    }

    func clearKerning(with range: NSRange) -> Self {
        self.removeAttribute(NSKernAttributeName, range: range)
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
