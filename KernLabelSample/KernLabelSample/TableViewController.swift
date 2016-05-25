//
//  TableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(Cell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sentences.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! Cell
        cell.label?.numberOfLines = 0
        cell.label?.text = "\(Sentences[indexPath.row])"
        return cell
    }
}

private class Cell: UITableViewCell {
    var label: KernLabel?
    var indexPath: NSIndexPath?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.label = KernLabel(frame: CGRectZero)
        self.label?.removeFromSuperview()
        self.label?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label!)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[view]-8-|",
            options: [],
            metrics: nil,
            views: ["view": self.label!]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-15-[view]-15-|",
            options: [],
            metrics: nil,
            views: ["view": self.label!]))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}