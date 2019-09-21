//
//  ColorDefinition.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/16.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import UIKit

/// 色の定義
public enum ColorDefinition {
    /// 設定地点の円の色
    public static let settingPointColors = [
        UIColor(hex: "FA6400"),
        UIColor(hex: "26AA52"),
        UIColor(hex: "4284F4"),
        UIColor.systemOrange,
        UIColor.systemPurple,
        UIColor.systemGray,
        UIColor.systemYellow,
        UIColor.black,
        UIColor.brown
    ]

    /// モーダル内のピンの背景色
    public static let underViewColorsOnModal = [
        UIColor(hex: "FA6400", alpha: 0.16),
        UIColor(hex: "26AA52", alpha: 0.16),
        UIColor(hex: "4284F4", alpha: 0.16)
    ]
}
