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
    private var testResultView1 = TestResultView1()
    private var testResultView2 = TestResultView2()

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
        self.testResultView1.needsPerform = true
        self.testResultView2.needsPerform = true
        self.testResultView1.text = self.textView.text
        self.testResultView2.text = self.textView.text
        self.testResultView1.setNeedsDisplay()
        self.testResultView2.setNeedsDisplay()
    }
}


private class TestResultView: UIView {

    var needsPerform = false
    var text = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fillRectWhite(context: CGContext?) {

        guard let context = context else { return }

        // Clear with white color
        CGContextSetRGBFillColor(context, 1, 1, 1, 1)
        CGContextFillRect(context, self.bounds)
    }
}

private class TestResultView1: TestResultView {

    private override func drawRect(rect: CGRect) {
        guard needsPerform else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        self.fillRectWhite(context)
        let str = NSAttributedString(string: self.text, attributes: [
            NSFontAttributeName: kTestFont
        ])
        let rect = CGRectMake(0, 0, self.frame.width, kTestFieldHeight)
        let time = PerformanceCheck.time {
            str.drawWithRect(rect, options: [.UsesLineFragmentOrigin], context: nil)
        }
        let height = str.boundingRectWithSize(rect.size, options: [.UsesLineFragmentOrigin], context: nil).height
        NSAttributedString(string: "\(time) ms").drawInRect(rect.offsetBy(dx: 0, dy: height + 5))
        self.needsPerform = false
    }
}

private class TestResultView2: TestResultView {

    private override func drawRect(rect: CGRect) {
        guard needsPerform else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        self.fillRectWhite(context)
        let str = KernTypeString(string: self.text, attributes: [
            NSFontAttributeName: kTestFont
        ])
        let rect = CGRectMake(0, 0, self.frame.width, kTestFieldHeight)
        let time = PerformanceCheck.time {
            str.drawWithRect(rect, options: [.UsesLineFragmentOrigin], context: context)
        }
        let height = str.boundingHeight(rect.size.width, options: [.UsesLineFragmentOrigin], numberOfLines: 0, context: nil)
        NSAttributedString(string: "\(time) ms").drawInRect(rect.offsetBy(dx: 0, dy: height + 5))
        self.needsPerform = false
    }
}

//
// MARK: - UITableViewDataSource
//
extension SpeedTestViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
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
        return kTestFieldHeight + kTestFieldPadding * 2
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
            cell.contentView.addSubview(self.textView)
        case 1:
            switch indexPath.row {
            case 0:
                self.testResultView1.removeFromSuperview()
                self.testResultView1.frame = CGRectInset(cell.bounds, kTestFieldPadding, kTestFieldPadding)
                cell.contentView.addSubview(self.testResultView1)
            case 1:
                self.testResultView2.removeFromSuperview()
                self.testResultView2.frame = CGRectInset(cell.bounds, kTestFieldPadding, kTestFieldPadding)
                cell.contentView.addSubview(self.testResultView2)
            default:
                break
            }
        default: break
        }
        cell.selectionStyle = .None
        return cell
    }
}
