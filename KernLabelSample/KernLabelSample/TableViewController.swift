//
//  TableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/07/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


class TableViewController: UIViewController, TabBarChild {

    var tableView: UITableView!
    var tableViewStyle: UITableViewStyle = .Grouped

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(title: String) {
        self.init(nibName: nil, bundle: nil)
        self.title = title
    }

    convenience init(style: UITableViewStyle) {
        self.init()
        self.tableViewStyle = style
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds, style: self.tableViewStyle)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = nil
        self.tableView.tableFooterView = nil
        self.view = self.tableView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsetsMake(
            self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension TableViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension TableViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
