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

    var heights: [IndexPath: CGFloat] = [:]
    var images: [IndexPath: CGImage?] = [:]
    var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(LayerTableCell.self, forCellReuseIdentifier: "LayerTableCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.numberOfRows = 400
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        let image = type.createImage(CGRect(x: 0, y: 0, width: tableView.frame.width - 30, height: height - 30), options: [])
        self.images[indexPath] = image
        return height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerTableCell", for: indexPath) as! LayerTableCell
        cell.titleLayer.frame = CGRect(x: 15, y: 15, width: cell.frame.width - 30, height: cell.frame.height - 30)
        cell.titleLayer.contents = self.images[indexPath]!
        return cell
    }
}


private class LayerTableCell: UITableViewCell {

    var type: KernTypeString!
    var indexPath: IndexPath?
    var titleLayer = CALayer()

    static let font = UIFont.systemFont(ofSize: Device.isPad ? 24 : 16)

    static var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.isOpaque = true
        self.contentView.layer.addSublayer(self.titleLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
