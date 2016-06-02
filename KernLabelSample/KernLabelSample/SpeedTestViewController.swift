//
//  SpeedTestViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/06/02.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


private let kTestString = "あああああああああ」「」「」、、、「」…「、。あああああ」、あああ（）「」あああああああああああいいいいいいいいいいいいいいいいいいいい"

class SpeedTestViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Speed Test"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        let _view = SpeedTestView(frame: self.view.bounds)
        _view.backgroundColor = UIColor.whiteColor()
        self.view = _view
    }
}

class SpeedTestView: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let k = KernTypeString(string: kTestString)
        let s = NSAttributedString(string: kTestString)

        let sRect = CGRectMake(20, 100, self.frame.width - 40, 120)
        let kRect = CGRectMake(20, 240, self.frame.width - 40, 120)

        PerformanceCheck.time {
            s.drawWithRect(sRect, options: [.UsesLineFragmentOrigin], context: nil)
        }

        PerformanceCheck.time {
            k.drawWithRect(kRect, options: [.UsesLineFragmentOrigin], context: context)
        }
    }
}
