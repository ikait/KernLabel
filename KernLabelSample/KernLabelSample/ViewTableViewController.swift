//
//  ViewTableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


class ViewTableViewController: TableViewController {

    var heights: [NSIndexPath: CGFloat] = [:]
    var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(ViewTableCell.self, forCellReuseIdentifier: "ViewTableCell")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.numberOfRows = 400
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = self.heights[indexPath] {
            return height
        }
        let type = KernTypeString(
            string: Sentences[indexPath.row % Sentences.count], attributes: TitleView.attributes)
        let height = type.boundingHeight(
            tableView.frame.width - 30, options: [], numberOfLines: 0, context: nil) + 30
        self.heights[indexPath] = height
        return height
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewTableCell", forIndexPath: indexPath) as! ViewTableCell
        cell.titleView.text = Sentences[indexPath.row % Sentences.count]
        cell.titleView.frame = CGRectMake(15, 15, cell.frame.width - 30, cell.frame.height - 30)
        cell.titleView.setNeedsDisplay()
        return cell
    }
}


private class ViewTableCell: UITableViewCell {

    var titleView = TitleView(frame: CGRectZero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private class TitleView: UIView {

    var text = ""

    static var attributes: [String : AnyObject] {
        var paragraphStyle: NSParagraphStyle {
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 1.2
            return style
        }
        return [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont.systemFontOfSize(Device.isPad ? 24 : 16)
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let type = KernTypeString(string: self.text, attributes: self.dynamicType.attributes)
        type.drawWithRect(rect, options: .UsesLineFragmentOrigin, context: context)
    }
}