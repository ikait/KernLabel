//
//  Device.swift
//  KernLabelSample
//
//  Created by Taishi Ikai on 2016/07/04.
//  Copyright © 2016年 Taishi Ikai. All rights reserved.
//

import UIKit


final class Device {

    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
