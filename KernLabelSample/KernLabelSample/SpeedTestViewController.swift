//
//  SpeedTestViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/06/02.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


private let kTestString = "あああああああああ」「」「」、、、「」…「、。あああああ」、あああ（）「」あああああああああああいいいいいいいいいいいいいいいいいいいい"
private let kTestFont = UIFont.systemFontOfSize(16)
private let kTestFieldHeight: CGFloat = 150
private let kTestFieldPadding: CGFloat = 10


class SpeedTestViewController: TableViewController {

    var textView = UITextView(frame: CGRectMake(0, 0, 0, kTestFieldHeight))
    var startButton = UIBarButtonItem()
    var speedTestView = SpeedTestView()

    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = "Speed Test"
    }

    convenience init() {
        self.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.prepareTextView()
    }

    private func prepareTextView() {
        self.textView.text = kTestString
        self.textView.font = kTestFont
        self.textView.autocorrectionType = .No
        self.textView.autocapitalizationType = .None
        self.textView.allowsEditingTextAttributes = false
        self.textView.spellCheckingType = .No
        self.textView.dataDetectorTypes = .None
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = UIEdgeInsetsZero
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareStartButton()
        self.setNavigationBar(
            self.title, leftBarButtonItems: nil, rightBarButtonItems: [self.startButton])
    }

    func prepareStartButton() {
        self.startButton = UIBarButtonItem(
            title: "Start",
            style: .Plain,
            target: self,
            action: #selector(SpeedTestViewController.performSpeedTest))
    }

    func performSpeedTest() {
        self.textView.resignFirstResponder()
        self.speedTestView.needsPerform = true
        self.speedTestView.text = self.textView.text
        self.speedTestView.setNeedsDisplay()
    }
}


class SpeedTestView: UIView {

    var needsPerform = false
    var text = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        guard needsPerform else {
            return
        }
        let context = UIGraphicsGetCurrentContext()

        // Clear with white color
        CGContextSetRGBFillColor(context, 1, 1, 1, 1)
        CGContextFillRect(context, rect)

        let s = NSAttributedString(string: self.text, attributes: [
            NSFontAttributeName: kTestFont
        ])
        let k = KernTypeString(string: self.text, attributes: [
            NSFontAttributeName: kTestFont
        ])

        let sRect = CGRectMake(0, 0, self.frame.width, kTestFieldHeight)
        let sTime = PerformanceCheck.time {
            s.drawWithRect(sRect, options: [.UsesLineFragmentOrigin], context: nil)
        }
        let sBRect = s.boundingRectWithSize(sRect.size, options: [.UsesLineFragmentOrigin], context: nil)
        NSAttributedString(string: "\(sTime) ms").drawInRect(sRect.offsetBy(dx: 0, dy: sBRect.height + 5))

        let kRect = sRect.offsetBy(dx: 0, dy: sRect.height)
        let kTime = PerformanceCheck.time {
            k.drawWithRect(kRect, options: [.UsesLineFragmentOrigin], context: context)
        }
        let kBRect = s.boundingRectWithSize(kRect.size, options: [.UsesLineFragmentOrigin], context: nil)
        NSAttributedString(string: "\(kTime) ms").drawInRect(kRect.offsetBy(dx: 0, dy: kBRect.height + 5))

        self.needsPerform = false
    }
}

//
// MARK: - UITableViewDataSource
//
extension SpeedTestViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Texts for testing"
        case 1:
            return "Results"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (kTestFieldHeight + kTestFieldPadding * 2) * (indexPath.section == 0 ? 1 : 2)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            self.textView.removeFromSuperview()
            self.textView.frame = CGRectInset(cell.bounds, kTestFieldPadding, kTestFieldPadding)
            cell.selectionStyle = .None
            cell.contentView.addSubview(self.textView)
        case 1:
            self.speedTestView.removeFromSuperview()
            self.speedTestView.frame = CGRectInset(cell.bounds, kTestFieldPadding, kTestFieldPadding)
            cell.userInteractionEnabled = false
            cell.contentView.addSubview(self.speedTestView)
        default: break
        }
        return cell
    }
}