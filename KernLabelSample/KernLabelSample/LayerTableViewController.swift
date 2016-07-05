//
//  TableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


class LayerTableViewController: TableViewController {

    var heights: [NSIndexPath: CGFloat] = [:]
    var images: [NSIndexPath: CGImage?] = [:]
    var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(LayerTableCell.self, forCellReuseIdentifier: "LayerTableCell")
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
        let type = KernTypeString(string: Sentences[indexPath.row % Sentences.count], attributes: [
            NSParagraphStyleAttributeName: LayerTableCell.paragraphStyle,
            NSFontAttributeName: LayerTableCell.font
        ])
        let height = type.boundingHeight(
            tableView.frame.width - 30, options: [], numberOfLines: 0, context: nil) + 30
        self.heights[indexPath] = height
        let image = type.createImage(CGRectMake(0, 0, tableView.frame.width - 30, height - 30), options: [])
        self.images[indexPath] = image
        return height
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LayerTableCell", forIndexPath: indexPath) as! LayerTableCell
        cell.titleLayer.frame = CGRectMake(15, 15, cell.frame.width - 30, cell.frame.height - 30)
        cell.titleLayer.contents = self.images[indexPath]!
        return cell
    }
}


private class LayerTableCell: UITableViewCell {

    var type: KernTypeString!
    var indexPath: NSIndexPath?
    var titleLayer = CALayer()

    static let font = UIFont.systemFontOfSize(Device.isPad ? 24 : 16)

    static var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        self.opaque = true
        self.contentView.layer.addSublayer(self.titleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}