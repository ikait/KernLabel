//
//  ViewController.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/05/28.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit
import KernLabel


private let kLabelHeight: CGFloat = 130


class ViewController: TableViewController {

    var uiLabel = UILabel()
    var kernLabel = KernLabel()
    var text = ""
    var numberOfLines = 0
    var textAlignment = NSTextAlignment.Left
    var kerningMode = KernLabelKerningMode.Normal
    var kerningParenSwitch = UISwitch()
    var alignmentSegmentedControl = UISegmentedControl()

    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.title = "KernLabel Sample"
    }

    convenience init() {
        self.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareText()
        self.prepareKerningParentSwitch()
        self.prepareAlignmentSegmentedControl()
    }

    private func prepareText() {
        self.text = ""
        self.text += "【行頭つめ】あいう「えお」「か」、！？\n"
        self.text += "（連続）する約物「：」！「」、。；折り返し「１」「２」「３」「４」\n"
        self.text += "英数123abc＠“ん”〘〛｛［』〕…【括弧）終\n"
        self.text += "2016年1月1日（金）"
    }

    private func prepareUILabel(with cell: UITableViewCell) {
        self.uiLabel.removeFromSuperview()
        if #available(iOS 9.0, *) {
            self.uiLabel.frame = cell.readableContentGuide.layoutFrame
            self.uiLabel.frame.origin.y = 0
            self.uiLabel.frame.size.height = kLabelHeight
        } else {
            self.uiLabel.frame = CGRectInset(cell.bounds, 10, 0)
        }
        self.uiLabel.text = self.text
        self.uiLabel.backgroundColor = UIColor.whiteColor()
        self.uiLabel.numberOfLines = 0
        self.uiLabel.textAlignment = self.textAlignment
        cell.contentView.addSubview(self.uiLabel)
    }

    private func prepareKernLabel(with cell: UITableViewCell) {
        self.kernLabel.removeFromSuperview()
        if #available(iOS 9.0, *) {
            self.kernLabel.frame = cell.readableContentGuide.layoutFrame
            self.kernLabel.frame.origin.y = 0
            self.kernLabel.frame.size.height = kLabelHeight
        } else {
            self.kernLabel.frame = CGRectInset(cell.bounds, 10, 0)
        }
        self.kernLabel.text = self.text
        self.kernLabel.backgroundColor = UIColor.whiteColor()
        self.kernLabel.numberOfLines = 0
        self.kernLabel.textAlignment = self.textAlignment
        self.kernLabel.kerningMode = self.kerningMode
        cell.contentView.addSubview(self.kernLabel)
    }

    private func prepareKerningParentSwitch() {
        self.kerningParenSwitch = UISwitch()
        self.kerningParenSwitch.addTarget(
            self,
            action: #selector(ViewController.handlerKerningParenSwitch(_:)),
            forControlEvents: .ValueChanged)
    }

    private func prepareAlignmentSegmentedControl() {
        self.alignmentSegmentedControl = UISegmentedControl(items: [
            "Left", "Center", "Right"
        ])
        self.alignmentSegmentedControl.addTarget(
            self,
            action: #selector(ViewController.handlerAlignmentSegmentedControl(_:)),
            forControlEvents: .ValueChanged)
    }

    @objc private func handlerAlignmentSegmentedControl(segmentedControl: UISegmentedControl) {
        self.textAlignment = {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return .Left
            case 1: return .Center
            case 2: return .Right
            default: return .Left
            }
        }()
        self.tableView.reloadData()
    }

    @objc private func handlerKerningParenSwitch(_switch: UISwitch) {
        self.kerningMode = _switch.on ? .All : .Normal
        self.tableView.reloadData()
    }
}

//
// MARK: - UITableViewDataSource
//
extension ViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "\(KernLabel.self)"
        case 1:
            return "\(UILabel.self)"
        case 2:
            return "Preferences"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 2 : 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 2 ? UITableViewAutomaticDimension : kLabelHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "UITableViewCell")
        cell.bounds.size.width = tableView.bounds.width
        switch indexPath.section {
        case 0:
            self.prepareKernLabel(with: cell)
        case 1:
            self.prepareUILabel(with: cell)
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Alignment"
                cell.accessoryView = self.alignmentSegmentedControl
                cell.accessoryView?.sizeToFit()
            case 1:
                cell.textLabel?.text = "Kerning parentheses"
                cell.detailTextLabel?.text = "Only KernLabel"
                cell.accessoryView = self.kerningParenSwitch
            default:
                break
            }
            cell.selectionStyle = .None
        default:
            break
        }
        return cell
    }
}
