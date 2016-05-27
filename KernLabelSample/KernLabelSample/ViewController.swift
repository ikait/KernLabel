//
//  ViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/28.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        let text = "【行頭つめ】あいうえお「かきくけこ」「さ」、ああああああああああああ「：」！「「」」、。\nああ123いいabcうう【】【【】】…【】"
        let frame = CGRectMake(10, 100, self.view.frame.width - 20, 120)
        let backgroundColor = UIColor.lightGrayColor()
        let numberOfLines = 0

        let label = UILabel()
        label.frame = frame
        label.backgroundColor = backgroundColor
        label.text = "\(UILabel.self)\n\n\(text)"
        label.numberOfLines = numberOfLines
        self.view.addSubview(label)

        let klabel = KernLabel()
        klabel.frame = frame.offsetBy(dx: 0, dy: frame.height + 20)
        klabel.backgroundColor = backgroundColor
        klabel.text = "\(KernLabel.self)\n\n\(text)"
        klabel.numberOfLines = numberOfLines
        self.view.addSubview(klabel)
    }

}
