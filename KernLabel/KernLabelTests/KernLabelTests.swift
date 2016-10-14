//
//  KernLabelTests.swift
//  KernLabelTests
//
//  Created by Taishi Ikai on 2016/06/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import FBSnapshotTestCase
@testable import KernLabel


private let kYakumono = "【…！「」、｛」《』［？！〉＝「：」；「」！。【】…【」"
private let kTextKana = [
    "【宮沢賢治】（ポラーノの広場）あのイーハトーヴォのすきとおった風、",
    "夏でも底に冷たさをもつ青いそら、\n",
    "（なつでもそこにつめたさをもつあおいそら）、「」…【】。［（〕《）\n",
    "うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。",
].joined(separator: "")


class KernLabelTests: FBSnapshotTestCase {

    var label: KernLabel!

    override func setUp() {
        super.setUp()
        self.label = KernLabel()
        self.label.bounds = CGRect(x: 0, y: 0, width: 400, height: 200)
        self.recordMode = false
    }

    override func tearDown() {
        super.tearDown()
        self.label = nil
    }

    // MARK: - textAlignment: Left

    func testDrawLeftKerningMinimum() {
        self.label.textAlignment = .left
        self.label.text = kTextKana
        self.label.kerningMode = .minimum
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningNormal() {
        self.label.textAlignment = .left
        self.label.text = kTextKana
        self.label.kerningMode = .normal
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningAll() {
        self.label.textAlignment = .left
        self.label.text = kTextKana
        self.label.kerningMode = .all
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningNormalTruncate() {
        self.label.bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.label.kerningMode = .normal
        self.label.textAlignment = .left
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Center

    func testDrawCenterKerningMinimum() {
        self.label.textAlignment = .center
        self.label.kerningMode = .minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningNormal() {
        self.label.textAlignment = .center
        self.label.kerningMode = .normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningAll() {
        self.label.textAlignment = .center
        self.label.kerningMode = .all
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningNormalTruncate() {
        self.label.bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.label.kerningMode = .normal
        self.label.textAlignment = .center
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Right

    func testDrawRightKerningMinimum() {
        self.label.textAlignment = .right
        self.label.kerningMode = .minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningNormal() {
        self.label.textAlignment = .right
        self.label.kerningMode = .normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningAll() {
        self.label.textAlignment = .right
        self.label.kerningMode = .all
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningNormalTruncate() {
        self.label.bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.label.kerningMode = .normal
        self.label.textAlignment = .right
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Justified

    func testDrawJustifiedKerningMinimum() {
        self.label.textAlignment = .justified
        self.label.kerningMode = .minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningNormal() {
        self.label.textAlignment = .justified
        self.label.kerningMode = .normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningAll() {
        self.label.textAlignment = .justified
        self.label.kerningMode = .all
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningNormalTruncate() {
        self.label.bounds = CGRect(x: 0, y: 0, width: 200, height: 100)
        self.label.kerningMode = .normal
        self.label.textAlignment = .justified
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }
}
