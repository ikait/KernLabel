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
            let font = curAttrs[.font] as? UIFont ?? kDefaultFont
            this.addAttribute(.kern, value: font.pointSize * value, range: NSMakeRange(location, length))
        }
        return self
    }

    func kerning(with settings: KerningSettings) -> Self {
        settings.forEach { body in
            self.kerning(body.0, value: body.1)
        }
        return self
    }

    func kerningValueSum(_ regexp: NSRegularExpression, value: CGFloat = 0 - kCharacterHalfSpace) -> CGFloat {
        var kernValueSum: CGFloat = 0
        regexp.enumerateMatches(in: self.string, options: [], range: NSMakeRange(0, self.length)) { [weak self] (result, _, _) in
            guard let result = result, let this = self else { return }
            let (location, _) = (result.range.location, result.range.length)
            let curAttrs = this.attributes(at: location, effectiveRange: nil)
            let font = curAttrs[.font] as? UIFont ?? kDefaultFont
            kernValueSum += font.pointSize * value
        }
        return kernValueSum
    }

    func kerningValueSum(with settings: KerningSettings) -> CGFloat {
        var kernValueSum: CGFloat = 0
        settings.forEach { body in
            kernValueSum += self.kerningValueSum(body.0, value: body.1)
        }
        return kernValueSum
    }

    func clearKerning(with range: NSRange) -> Self {
        self.removeAttribute(.kern, range: range)
        return self
    }

    func setAttributes(attrs: [NSAttributedStringKey : Any]) {
        self.addAttributes(attrs, range: NSMakeRange(0, self.length))
    }
}
