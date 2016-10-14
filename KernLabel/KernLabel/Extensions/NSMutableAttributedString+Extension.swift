//
//  NSMutableAttributedString+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


private let kDefaultFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)

extension NSMutableAttributedString {

    @discardableResult
    func kerning(_ regexp: NSRegularExpression, value: CGFloat = 0 - kCharacterHalfSpace) -> Self {
        regexp.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, let this = self else { return }
            let (location, length) = (result.range.location, result.range.length)
            let curAttrs = this.attributes(at: location, effectiveRange: nil)
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

    func kerningValueSum(_ regexp: NSRegularExpression, value: CGFloat = 0 - kCharacterHalfSpace) -> CGFloat {
        var kernValueSum: CGFloat = 0
        regexp.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, let this = self else { return }
            let (location, _) = (result.range.location, result.range.length)
            let curAttrs = this.attributes(at: location, effectiveRange: nil)
            let font = curAttrs[NSFontAttributeName] as? UIFont ?? kDefaultFont
            kernValueSum += font.pointSize * value
        }
        return kernValueSum
    }

    func kerningValueSum(with settings: KerningSettings) -> CGFloat {
        var kernValueSum: CGFloat = 0
        settings.forEach { (regexp, value) in
            kernValueSum += self.kerningValueSum(regexp, value: value)
        }
        return kernValueSum
    }

    func clearKerning(with range: NSRange) -> Self {
        print(self.length)
        self.removeAttribute(NSKernAttributeName, range: range)
        return self
    }

    override var attributes: [String : Any] {
        get {
            return super.attributes
        }
        set {
            self.addAttributes(newValue, range: NSMakeRange(0, self.length))
        }
    }
}
