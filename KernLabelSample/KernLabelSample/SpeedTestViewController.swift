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
private let kTestFont = UIFont.systemFont(ofSize: 16)
private let kTestFieldHeight: CGFloat = 150
private let kTestFieldPadding: CGFloat = 10


class SpeedTestViewController: TableViewController {

    var textView = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: kTestFieldHeight))
    var startButton = UIBarButtonItem()
    fileprivate var testResultView1 = TestResultView1()
    fileprivate var testResultView2 = TestResultView2()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.prepareTextView()
    }

    fileprivate func prepareTextView() {
        self.textView.text = kTestString
        self.textView.font = kTestFont
        self.textView.autocorrectionType = .no
        self.textView.autocapitalizationType = .none
        self.textView.allowsEditingTextAttributes = false
        self.textView.spellCheckingType = .no
        self.textView.dataDetectorTypes = UIDataDetectorTypes()
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = UIEdgeInsets.zero
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareStartButton()
        self.setNavigationBar(
            self.title, leftBarButtonItems: nil, rightBarButtonItems: [self.startButton])
    }

    func prepareStartButton() {
        self.startButton = UIBarButtonItem(
            title: "Start",
            style: .plain,
            target: self,
            action: #selector(SpeedTestViewController.performSpeedTest))
    }

    @objc
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
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func fillRectWhite(_ context: CGContext?) {

        guard let context = context else { return }

        // Clear with white color
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fill(self.bounds)
    }
}

private class TestResultView1: TestResultView {

    fileprivate override func draw(_ rect: CGRect) {
        guard needsPerform else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        self.fillRectWhite(context)
        let str = NSAttributedString(string: self.text, attributes: [
            .font: kTestFont
        ])
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: kTestFieldHeight)
        let time = PerformanceCheck.time {
            str.draw(with: rect, options: [.usesLineFragmentOrigin], context: nil)
        }
        let height = str.boundingRect(with: rect.size, options: [.usesLineFragmentOrigin], context: nil).height
        NSAttributedString(string: "\(time) ms").draw(in: rect.offsetBy(dx: 0, dy: height + 5))
        self.needsPerform = false
    }
}

private class TestResultView2: TestResultView {

    fileprivate override func draw(_ rect: CGRect) {
        guard needsPerform else {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        self.fillRectWhite(context)
        let str = KernTypeString(string: self.text, attributes: [
            .font: kTestFont
        ])
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: kTestFieldHeight)
        let time = PerformanceCheck.time {
            str.drawWithRect(rect, options: [.usesLineFragmentOrigin], context: context)
        }
        let height = str.boundingHeight(rect.size.width, options: [.usesLineFragmentOrigin], numberOfLines: 0, context: nil)
        NSAttributedString(string: "\(time) ms").draw(in: rect.offsetBy(dx: 0, dy: height + 5))
        self.needsPerform = false
    }
}

//
// MARK: - UITableViewDataSource
//
extension SpeedTestViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Texts for testing"
        case 1:
            return "Results"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTestFieldHeight + kTestFieldPadding * 2
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch (indexPath as NSIndexPath).section {
        case 0:
            self.textView.removeFromSuperview()
            self.textView.frame = cell.bounds.insetBy(dx: kTestFieldPadding, dy: kTestFieldPadding)
            cell.contentView.addSubview(self.textView)
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0:
                self.testResultView1.removeFromSuperview()
                self.testResultView1.frame = cell.bounds.insetBy(dx: kTestFieldPadding, dy: kTestFieldPadding)
                cell.contentView.addSubview(self.testResultView1)
            case 1:
                self.testResultView2.removeFromSuperview()
                self.testResultView2.frame = cell.bounds.insetBy(dx: kTestFieldPadding, dy: kTestFieldPadding)
                cell.contentView.addSubview(self.testResultView2)
            default:
                break
            }
        default: break
        }
        cell.selectionStyle = .none
        return cell
    }
}
