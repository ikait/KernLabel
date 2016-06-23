//
//  TestSettings.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/06/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


let kCGFloatHuge: CGFloat = CGFloat(2^12)
let kText = "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。"

final class TestSettings {

    static var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }

    static var font: UIFont {
        return UIFont.systemFontOfSize(24)
    }

    static var attributes: [String : AnyObject] {
        return [
            NSParagraphStyleAttributeName: self.paragraphStyle,
            NSFontAttributeName: self.font
        ]
    }

    static func text(string: String,
                     attributes: [String : AnyObject] = TestSettings.attributes
        ) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: attributes)
    }

}