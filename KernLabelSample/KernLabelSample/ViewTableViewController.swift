//
//  ViewTableViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/25.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


class Queue<T: Hashable> {
    var queue = OperationQueue()
    var operations = [T: Operation]()

    func add(operation key: T, block: @escaping () -> ()) {
        let op = BlockOperation(block: block)
        self.operations[key] = op
        self.queue.addOperation(op)
    }

    func cancel(operation key: T) {
        guard let op = self.operations[key] else {
            return
        }
        op.cancel()
    }

    func cancelAllOperations() {
        self.queue.cancelAllOperations()
    }
}


class ViewTableViewController: TableViewController {

    var heights: [IndexPath: CGFloat] = [:]
    var numberOfRows = 1000
    var queue = Queue<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ViewTableCell.self, forCellReuseIdentifier: "ViewTableCell")
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
            tableView.frame.width - 20, options: [], numberOfLines: 0, context: nil) + 20
        self.heights[indexPath] = height
        return height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTableCell", for: indexPath) as! ViewTableCell
        cell.titleView.text = Sentences[(indexPath as NSIndexPath).row % Sentences.count]
        cell.titleView.frame = CGRect(x: 10, y: 10, width: cell.frame.width - 20, height: cell.frame.height - 20)

        self.queue.add(operation: indexPath) {
            let type = KernTypeString(string: cell.titleView.text, attributes: TitleView.attributes)
            let image = type.createImage(cell.titleView.bounds, options: .usesLineFragmentOrigin)
            DispatchQueue.main.async {
                cell.titleView.layer.contents = image
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.queue.cancel(operation: indexPath)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.queue.cancelAllOperations()
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
}
