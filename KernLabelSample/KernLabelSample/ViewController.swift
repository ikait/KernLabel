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
    var textAlignment = NSTextAlignment.left
    var kerningMode = KernLabelKerningMode.normal
    var kerningModeSegmentedControl = UISegmentedControl()
    var alignmentSegmentedControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareText()
        self.prepareAlignmentSegmentedControl()
        self.prepareKerningModeSegmentedControl()
    }

    fileprivate func prepareText() {
        self.text = """
        【行頭つめ】あいう「えお」「か」、！？
        （連続）する約物「：」！「」、。；折り返し「１」（２）〈３〉【４】［５］《６》
        英数123abc＠“ん”〘〛｛［』〕…【括弧）終
        2016年1月1日（金）
        """
    }

    fileprivate func prepareUILabel(with cell: UITableViewCell) {
        self.uiLabel.removeFromSuperview()
        if #available(iOS 9.0, *) {
            self.uiLabel.frame = cell.readableContentGuide.layoutFrame
            self.uiLabel.frame.origin.y = 0
            self.uiLabel.frame.size.height = kLabelHeight
        } else {
            self.uiLabel.frame = cell.bounds.insetBy(dx: 10, dy: 0)
        }
        self.uiLabel.frame.size.height = kLabelHeight
        self.uiLabel.text = self.text
        self.uiLabel.backgroundColor = UIColor.white
        self.uiLabel.numberOfLines = 0
        self.uiLabel.textAlignment = self.textAlignment
        cell.contentView.addSubview(self.uiLabel)
    }

    fileprivate func prepareKernLabel(with cell: UITableViewCell) {
        self.kernLabel.removeFromSuperview()
        if #available(iOS 9.0, *) {
            self.kernLabel.frame = cell.readableContentGuide.layoutFrame
            self.kernLabel.frame.origin.y = 0
        } else {
            self.kernLabel.frame = (cell.bounds).insetBy(dx: 10, dy: 0)
        }
        self.kernLabel.frame.size.height = kLabelHeight
        self.kernLabel.text = self.text
        self.kernLabel.backgroundColor = UIColor.white
        self.kernLabel.numberOfLines = 0
        self.kernLabel.textAlignment = self.textAlignment
        self.kernLabel.kerningMode = self.kerningMode
        cell.contentView.addSubview(self.kernLabel)
    }

    fileprivate func prepareAlignmentSegmentedControl() {
        self.alignmentSegmentedControl = UISegmentedControl(items: [
            "Left", "Center", "Right", "Justified"
        ])
        self.alignmentSegmentedControl.addTarget(
            self,
            action: #selector(ViewController.handlerAlignmentSegmentedControl(_:)),
            for: .valueChanged)
        self.alignmentSegmentedControl.selectedSegmentIndex = 0
    }

    fileprivate func prepareKerningModeSegmentedControl() {
        self.kerningModeSegmentedControl = UISegmentedControl(items: [
            "None", "Minimum", "Normal", "All"
        ])
        self.kerningModeSegmentedControl.addTarget(
            self,
            action: #selector(ViewController.handlerKerningModeSegmentedControl(_:)),
            for: .valueChanged)
        self.kerningModeSegmentedControl.selectedSegmentIndex = 2
    }

    @objc fileprivate func handlerAlignmentSegmentedControl(_ segmentedControl: UISegmentedControl) {
        self.textAlignment = {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return .left
            case 1: return .center
            case 2: return .right
            case 3: return .justified
            default: return .left
            }
        }()
        self.tableView.reloadData()
    }

    @objc fileprivate func handlerKerningModeSegmentedControl(_ segmentedControl: UISegmentedControl) {
        self.kerningMode = {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return .none
            case 1: return .minimum
            case 2: return .normal
            case 3: return .all
            default: return .none
            }
        }()
        self.tableView.reloadData()
    }
}

//
// MARK: - UITableViewDataSource
//
extension ViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath as NSIndexPath).section == 2 ? UITableViewAutomaticDimension : kLabelHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        cell.bounds.size.width = tableView.bounds.width
        switch (indexPath as NSIndexPath).section {
        case 0:
            self.prepareKernLabel(with: cell)
        case 1:
            self.prepareUILabel(with: cell)
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textLabel?.text = "Alignment"
                cell.accessoryView = self.alignmentSegmentedControl
                cell.accessoryView?.sizeToFit()
            case 1:
                cell.textLabel?.text = "Kerning parentheses"
                cell.detailTextLabel?.text = "Only KernLabel"
                cell.accessoryView = self.kerningModeSegmentedControl
                cell.accessoryView?.sizeToFit()
            default:
                break
            }
            cell.selectionStyle = .none
        default:
            break
        }
        return cell
    }
}
