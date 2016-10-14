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

    var heights: [IndexPath: CGFloat] = [:]
    var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ViewTableCell.self, forCellReuseIdentifier: "ViewTableCell")
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
        let type = KernTypeString(
            string: Sentences[indexPath.row % Sentences.count], attributes: TitleView.attributes)
        let height = type.boundingHeight(
            tableView.frame.width - 30, options: [], numberOfLines: 0, context: nil) + 30
        self.heights[indexPath] = height
        return height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTableCell", for: indexPath) as! ViewTableCell
        cell.titleView.text = Sentences[(indexPath as NSIndexPath).row % Sentences.count]
        cell.titleView.frame = CGRect(x: 15, y: 15, width: cell.frame.width - 30, height: cell.frame.height - 30)
        cell.titleView.setNeedsDisplay()
        return cell
    }
}


private class ViewTableCell: UITableViewCell {

    var titleView = TitleView(frame: CGRect.zero)

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
            NSFontAttributeName: UIFont.systemFont(ofSize: Device.isPad ? 24 : 16)
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let type = KernTypeString(string: self.text, attributes: type(of: self).attributes)
        type.drawWithRect(rect, options: .usesLineFragmentOrigin, context: context)
    }
}
