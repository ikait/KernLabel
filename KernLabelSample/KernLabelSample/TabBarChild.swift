//
//  TabBarChild.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/07/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


protocol TabBarChild: class {
}


extension TabBarChild where Self: UIViewController {

    func setNavigationBar(title: String? = nil,
                          leftBarButtonItems:[UIBarButtonItem]? = nil,
                          rightBarButtonItems: [UIBarButtonItem]? = nil) {
        self.tabBarController?.navigationItem.leftBarButtonItems = leftBarButtonItems
        self.tabBarController?.navigationItem.rightBarButtonItems = rightBarButtonItems
        self.tabBarController?.navigationItem.title = title ?? self.title
    }
}
