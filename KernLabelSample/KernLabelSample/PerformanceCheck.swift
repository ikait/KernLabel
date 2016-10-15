//
//  PerformanceCheck.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/06/02.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import Foundation


final class PerformanceCheck {

    static func time(_ sample: Int = 1000, target: (() -> Void)) -> TimeInterval {
        var opt = TimeInterval()
        var ms = 0.0
        let q = DispatchQueue(label: "\(target)", attributes: [])
        q.sync {
            let st = Date()
            [Int](0..<sample).forEach { _ in
                target()
            }
            opt = Date().timeIntervalSince(st)
            ms = opt * 1000 / Double(sample)
            print("\(ms) ms")
        }
        return ms
    }
}
