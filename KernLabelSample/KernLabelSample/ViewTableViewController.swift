//
//  ViewTableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel

class ViewTableViewController: UITableViewController {

    var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "View Table"
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ViewTableCell.self, forCellReuseIdentifier: "ViewTableCell")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewTableCell", forIndexPath: indexPath) as! ViewTableCell
        cell.label?.numberOfLines = 0
        cell.label?.attributedText = NSAttributedString(
            string: Sentences[indexPath.row],
            attributes: [
                NSParagraphStyleAttributeName: self.paragraphStyle,
                NSFontAttributeName: UIFont.systemFontOfSize(24)
            ]
        )
        return cell
    }
}

private class ViewTableCell: UITableViewCell {
    var label: KernLabel?
    var indexPath: NSIndexPath?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.label = KernLabel(frame: CGRectZero)
        self.label?.removeFromSuperview()
        self.label?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label!)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-15-[view]-15-|",
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