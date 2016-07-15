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
].joinWithSeparator("")


class KernLabelTests: FBSnapshotTestCase {

    var label: KernLabel!

    override func setUp() {
        super.setUp()
        self.label = KernLabel()
        self.label.bounds = CGRectMake(0, 0, 400, 200)
        self.recordMode = true
    }

    override func tearDown() {
        super.tearDown()
        self.label = nil
    }

    // MARK: - textAlignment: Left

    func testDrawLeftKerningMinimum() {
        self.label.textAlignment = .Left
        self.label.text = kTextKana
        self.label.kerningMode = .Minimum
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningNormal() {
        self.label.textAlignment = .Left
        self.label.text = kTextKana
        self.label.kerningMode = .Normal
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningAll() {
        self.label.textAlignment = .Left
        self.label.text = kTextKana
        self.label.kerningMode = .All
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawLeftKerningNormalTruncate() {
        self.label.bounds = CGRectMake(0, 0, 200, 100)
        self.label.kerningMode = .Normal
        self.label.textAlignment = .Left
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Center

    func testDrawCenterKerningMinimum() {
        self.label.textAlignment = .Center
        self.label.kerningMode = .Minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningNormal() {
        self.label.textAlignment = .Center
        self.label.kerningMode = .Normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningAll() {
        self.label.textAlignment = .Center
        self.label.kerningMode = .All
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerningNormalTruncate() {
        self.label.bounds = CGRectMake(0, 0, 200, 100)
        self.label.kerningMode = .Normal
        self.label.textAlignment = .Center
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Right

    func testDrawRightKerningMinimum() {
        self.label.textAlignment = .Right
        self.label.kerningMode = .Minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningNormal() {
        self.label.textAlignment = .Right
        self.label.kerningMode = .Normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningAll() {
        self.label.textAlignment = .Right
        self.label.kerningMode = .All
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerningNormalTruncate() {
        self.label.bounds = CGRectMake(0, 0, 200, 100)
        self.label.kerningMode = .Normal
        self.label.textAlignment = .Right
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    // MARK: - textAlignment: Justified

    func testDrawJustifiedKerningMinimum() {
        self.label.textAlignment = .Justified
        self.label.kerningMode = .Minimum
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningNormal() {
        self.label.textAlignment = .Justified
        self.label.kerningMode = .Normal
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningAll() {
        self.label.textAlignment = .Justified
        self.label.kerningMode = .All
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerningNormalTruncate() {
        self.label.bounds = CGRectMake(0, 0, 200, 100)
        self.label.kerningMode = .Normal
        self.label.textAlignment = .Justified
        self.label.text = kTextKana
        FBSnapshotVerifyLayer(self.label.layer)
    }
}
