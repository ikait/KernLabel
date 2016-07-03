//
//  TableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/07/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController, TabBarChild {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        self.tableView.contentInset = UIEdgeInsetsMake(
            self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
}
