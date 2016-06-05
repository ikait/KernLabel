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

    var heights: [NSIndexPath: CGFloat] = [:]

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
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 400
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = self.heights[indexPath] {
            return height
        }
        let type = KernTypeString(string: Sentences[indexPath.row % Sentences.count], attributes: [
            NSParagraphStyleAttributeName: ViewTableCellLayer.paragraphStyle,
            NSFontAttributeName: ViewTableCellLayer.font
        ])
        let height = type.boundingHeight(tableView.frame.width - 30, options: [], numberOfLines: 0, context: nil) + 30
        self.heights[indexPath] = height
        return height
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ViewTableCell", forIndexPath: indexPath) as! ViewTableCell
        cell.titleLayer.type.string = Sentences[indexPath.row % Sentences.count]
        cell.titleLayer.frame = CGRectMake(15, 15, cell.frame.width - 30, cell.frame.height - 30)
        cell.titleLayer.setNeedsDisplay()
        return cell
    }
}


private class ViewTableCell: UITableViewCell {
    var titleLayer = ViewTableCellLayer()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.addSublayer(self.titleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class ViewTableCellLayer: CALayer {
    var type: KernTypeString = KernTypeString(string: "")

    static var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }
    static let font = UIFont.systemFontOfSize(24)

    override init() {
        super.init()
        self.delegate = self
        self.contentsScale = UIScreen.mainScreen().scale
        self.type.attributes = [
            NSParagraphStyleAttributeName: ViewTableCellLayer.paragraphStyle,
            NSFontAttributeName: ViewTableCellLayer.font
        ]
    }

    override init(layer: AnyObject) {
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        self.type.drawWithRect(layer.bounds, options: .UsesLineFragmentOrigin, context: ctx)
    }
}

