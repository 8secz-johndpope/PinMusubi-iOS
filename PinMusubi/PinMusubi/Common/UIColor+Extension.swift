//
//  UIColor+Extension.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public extension UIColor {
    /// UIColorを16進数で初期化
    /// - Parameter hex: 16進数
    /// - Parameter alpha: 透明度
    convenience init(hex: String, alpha: CGFloat) {
        let hexInt = Int("000000" + hex, radix: 16) ?? 0
        let red = CGFloat(hexInt / Int(powf(256, 2)) % 256) / 255
        let green = CGFloat(hexInt / Int(powf(256, 1)) % 256) / 255
        let blue = CGFloat(hexInt / Int(powf(256, 0)) % 256) / 255
        self.init(red: red, green: green, blue: blue, alpha: min(max(alpha, 0), 1))
    }

    /// UIColorを16進数で初期化
    /// - Parameter hex: 16進数
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
