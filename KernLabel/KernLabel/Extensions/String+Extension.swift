//
//  String+Extension.swift
//  KernLabel
//
//  Created by ikai on 2016/05/26.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit

extension String {
    var length: Int {
        return self.characters.count
    }

    var isAlphanumeric: Bool {
        return self.rangeOfString("^[a-zA-Z0-9]+$", options: .RegularExpressionSearch) != nil
    }
}
