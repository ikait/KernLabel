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
private let kAll = "\(kText)\n\(kYakumono)"


class KernLabelTests: FBSnapshotTestCase {

    var label: KernLabel!

    override func setUp() {
        super.setUp()
        self.label = KernLabel()
        self.label.bounds = CGRectMake(0, 0, 400, 200)
        self.recordMode = false
    }

    override func tearDown() {
        super.tearDown()
        self.label = nil
    }

    func testDraw() {
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawKerning() {
        self.label.kerningMode = .All
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenter() {
        self.label.textAlignment = .Center
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawCenterKerning() {
        self.label.textAlignment = .Center
        self.label.kerningMode = .All
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRight() {
        self.label.textAlignment = .Right
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawRightKerning() {
        self.label.textAlignment = .Right
        self.label.kerningMode = .All
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustified() {
        self.label.textAlignment = .Justified
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawJustifiedKerning() {
        self.label.textAlignment = .Justified
        self.label.kerningMode = .All
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawTruncate() {
        self.label.bounds = CGRectMake(0, 0, 200, 100)
        self.label.text = kAll
        FBSnapshotVerifyLayer(self.label.layer)
    }

    func testDrawYakumono() {
        self.label.text = kYakumono
        FBSnapshotVerifyLayer(self.label.layer)
    }
}
