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


private let kRectHuge = CGRect(x: 0, y: 0, width: kCGFloatHuge, height: kCGFloatHuge)
private let kTextKana = [
    "【宮沢賢治】（ポラーノの広場）あのイーハトーヴォのすきとおった風、",
    "夏でも底に冷たさをもつ青いそら、\n",
    "（なつでもそこにつめたさをもつあおいそら）、「」…【】。［（〕《）\n",
    "うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波。",
].joined(separator: "")


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
            kRectHuge.size, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertLessThan(size.height,
                          TestSettings.font.pointSize * 2,
                          "Should size to less than two sizes.")
    }

    func testBoundingRectMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc123", attributes: TestSettings.attributes)
        let size = self.string.boundingRectWithSize(
            kRectHuge.size, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(size.height,
                             TestSettings.font.pointSize,
                             "Should size to greater than a size.")
    }

    func testBoundingHeightSingleLine() {
        self.string = KernTypeString(string: "あいうえお", attributes: TestSettings.attributes)
        let height = self.string.boundingHeight(1000, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(height, 0)
        XCTAssertLessThan(height, TestSettings.font.pointSize * 2)
    }

    func testBoundingHeightMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc", attributes: TestSettings.attributes)
        let height = self.string.boundingHeight(1000, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertGreaterThan(height, TestSettings.font.pointSize)
        XCTAssertLessThan(height, TestSettings.font.pointSize * 3)
    }

    func testBoundingWidthSingleLine() {
        self.string = KernTypeString(string: "あいうえお", attributes: TestSettings.attributes)
        let width = self.string.boundingWidth(1000, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertLessThanOrEqual(width, TestSettings.font.pointSize * 5)
    }

    func testBoundingWidthMultipleLine() {
        self.string = KernTypeString(string: "あいうえお\nabc123", attributes: TestSettings.attributes)
        let width = self.string.boundingWidth(1000, options: .usesLineFragmentOrigin, numberOfLines: 0, context: nil)
        XCTAssertLessThanOrEqual(width, TestSettings.font.pointSize * 5)
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

    func testDrawWithRectPerformance() {
        self.string = KernTypeString(string: kTextKana, attributes: TestSettings.attributes)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 200)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        XCTAssertNotNil(context)
        self.measure {
            self.string.drawWithRect(rect, options: [], context: context)
        }
    }

    func testCreateImagePerformance() {
        self.string = KernTypeString(string: kTextKana, attributes: TestSettings.attributes)
        let rect = CGRect(x: 0, y: 0, width: 500, height: 500)
        self.measure {
            self.string.createImage(rect, options: [])
        }
    }

}
