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
        return self.range(of: "^[a-zA-Z0-9]+$", options: .regularExpression) != nil
    }

    var first: String {
        return self.isEmpty ? "" : String(self.characters.first!) 
    }

    var last: String {
        return self.isEmpty ? "" : String(self.characters.last!)
    }
}
