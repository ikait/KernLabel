//
//  PerformanceCheck.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/06/02.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import Foundation


final class PerformanceCheck {

    static func time(sample: Int = 1000, target: (() -> Void)) -> NSTimeInterval {
        var opt = NSTimeInterval()
        var ms = 0.0
        let q = dispatch_queue_create("\(target)", DISPATCH_QUEUE_SERIAL)
        dispatch_sync(q) {
            let st = NSDate()
            [Int](0..<sample).forEach { _ in
                target()
            }
            opt = NSDate().timeIntervalSinceDate(st)
            ms = opt * 1000 / Double(sample)
            print("\(ms) ms")
        }
        return ms
    }
}