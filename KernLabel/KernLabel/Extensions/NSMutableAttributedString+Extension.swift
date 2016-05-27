//
//  NSMutableAttributedString+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit

private let k句読点 = "、，。．"
private let k括弧閉 = "｝］」』）｠〉》〕〙】〗"
private let k括弧開 = "｛［「『（｟〈《〔〘【〖"
private let k他約物 = "！？：；︰‐・…‥〜ー―※"

extension NSMutableAttributedString {
    var kerned: NSMutableAttributedString {
        let regexp = try! NSRegularExpression(pattern: "([\(k括弧閉)]?[\(k句読点)]?[\(k他約物)]?[\(k括弧開)])|([\(k括弧閉)][\(k句読点)]?[\(k他約物)]?)", options: [])
        regexp.matchesInString(self.string, options: [], range: NSMakeRange(0, self.length)).enumerate().forEach { result in
            let (location, length) = (result.element.range.location, result.element.range.length)
            let curAttrs = self.attributesAtIndex(location, effectiveRange: nil)
            let font = curAttrs[NSFontAttributeName] as? UIFont ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
            self.addAttributes([
                NSKernAttributeName: font.pointSize * -0.5,
                NSBackgroundColorAttributeName: UIColor.blueColor()
            ], range: NSMakeRange(location, length - 1))
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
