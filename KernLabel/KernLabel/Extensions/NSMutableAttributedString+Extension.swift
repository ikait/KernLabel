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

extension NSMutableAttributedString {
    var kerned: NSMutableAttributedString {
        let regexp = try! NSRegularExpression(pattern: "([\(k句読点)\(k括弧閉)][\(k括弧開)])|([\(k括弧閉)][\(k句読点)])|([(k括弧閉)][(k括弧閉)])", options: [])
        regexp.matchesInString(self.string, options: [], range: NSMakeRange(0, self.length)).enumerate().forEach { result in
            let index = result.element.range.location
            let curAttrs = self.attributesAtIndex(index, effectiveRange: nil)
            let font = curAttrs[NSFontAttributeName] as? UIFont ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
            self.addAttributes([
                NSKernAttributeName: font.pointSize * -0.5,
            ], range: NSMakeRange(index, 1))
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
