//
//  KernTypeStringTests.swift
//  KernLabel
//
//  Created by Taishi Ikai on 2016/06/03.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import KernLabel


private let kRectHuge = CGRectMake(0, 0, kCGFloatHuge, kCGFloatHuge)
private let kTextKana = [
    "【宮沢賢治】（ポラーノの広場）あのイーハトーヴォのすきとおった風、",
    "夏でも底に冷たさをもつ青いそら、\n",
    "（なつでもそこにつめたさをもつあおいそら）、「」…【】。［（〕《）\n",
    "うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。",
].joinWithSeparator("")


class KernTypeStringTests: FBSnapshotTestCase {

    var string: KernTypeString!

    override func setUp() {
        super.setUp()
        self.string = KernTypeString()
    }

    override func tearDown() {
        super.tearDown()
        self.string = nil
    }

    func testBoundingRectSingleLine() {
        self.string = KernTypeString(string: "あいうえお", attributes: TestSettings.attributes)
        let size = self.string.boundingRectWithSize(
            kRectHuge.size, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertLessThan(size.height,
                          TestSettings.font.pointSize * 2,
                          "Should size to less than two sizes.")
    }

    func testBoundingRectMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc123", attributes: TestSettings.attributes)
        let size = self.string.boundingRectWithSize(
            kRectHuge.size, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(size.height,
                             TestSettings.font.pointSize,
                             "Should size to greater than a size.")
    }

    func testBoundingHeightSingleLine() {
        self.string = KernTypeString(string: "あいうえお", attributes: TestSettings.attributes)
        let height = self.string.boundingHeight(1000, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(height, 0)
        XCTAssertLessThan(height, TestSettings.font.pointSize * 2)
    }

    func testBoundingHeightMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc", attributes: TestSettings.attributes)
        let height = self.string.boundingHeight(1000, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(height, TestSettings.font.pointSize)
        XCTAssertLessThan(height, TestSettings.font.pointSize * 3)
    }

    func testBoundingWidthSingleLine() {
        self.string = KernTypeString(string: "あいうえお", attributes: TestSettings.attributes)
        let width = self.string.boundingWidth(1000, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThanOrEqual(width, TestSettings.font.pointSize * 5)
    }

    func testBoundingWidthMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc123", attributes: TestSettings.attributes)
        let width = self.string.boundingWidth(1000, options: .UsesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThanOrEqual(width, TestSettings.font.pointSize * 5)
    }

    func testBoundingHeightToBeZero() {
        self.string = KernTypeString(string: "", attributes: TestSettings.attributes)
        let height1 = self.string.boundingHeight(1000, options: [], numberOfLines: 0, context: nil)
        XCTAssertEqual(height1, 0)

        let height2 = self.string.boundingHeight(0, options: [], numberOfLines: 0, context: nil)
        XCTAssertEqual(height2, 0)
    }

    func testBoundingWidthToBeZero() {
        self.string = KernTypeString(string: "", attributes: TestSettings.attributes)
        let width1 = self.string.boundingWidth(1000, options: [], numberOfLines: 0, context: nil)
        XCTAssertEqual(width1, 0)

        let width2 = self.string.boundingHeight(0, options: [], numberOfLines: 0, context: nil)
        XCTAssertEqual(width2, 0)
    }

    func testDrawAtPointPerformance() {
        self.string = KernTypeString(string: kTextKana, attributes: TestSettings.attributes)
        let rect = CGRectMake(0, 0, 200, 200)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        XCTAssertNotNil(context)
        self.measureBlock {
            self.string.drawWithRect(rect, options: [], context: context)
        }
    }

    func testCreateImagePerformance() {
        self.string = KernTypeString(string: kTextKana, attributes: TestSettings.attributes)
        let rect = CGRectMake(0, 0, 500, 500)
        self.measureBlock {
            self.string.createImage(rect, options: [])
        }
    }

}
