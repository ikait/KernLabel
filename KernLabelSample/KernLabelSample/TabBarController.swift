//
//  TabBarController.swift
//  KernLabelSample
//
//  Created by ikai on 2016/05/30.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.viewControllers = [
            ViewController(title: "KernLabel Sample"),
            SpeedTestViewController(title: "Speed Test"),
            ViewTableViewController(title: "View Table"),
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
