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
        UIColor(hex: "FA6400"), // 橙
        UIColor(hex: "26AA52"), // 緑
        UIColor(hex: "4284F4"), // 青
        UIColor(hex: "E74C3C"), // 赤
        UIColor(hex: "F1C40F"), // 黄
        UIColor(hex: "1ABC9C"), // 青緑
        UIColor(hex: "9B59B6"), // 紫
        UIColor(hex: "95A5A6"), // 銀
        UIColor(hex: "34495E"), // 藍
        UIColor(hex: "FF8080")  // 薄赤
    ]

    /// モーダル内のピンの背景色
    public static let underViewColorsOnModal = [
        UIColor(hex: "FA6400", alpha: 0.16),    // 橙
        UIColor(hex: "26AA52", alpha: 0.16),    // 緑
        UIColor(hex: "4284F4", alpha: 0.16),    // 青
        UIColor(hex: "E74C3C", alpha: 0.16),    // 赤
        UIColor(hex: "F1C40F", alpha: 0.16),    // 黄
        UIColor(hex: "1ABC9C", alpha: 0.16),    // 青緑
        UIColor(hex: "9B59B6", alpha: 0.16),    // 紫
        UIColor(hex: "95A5A6", alpha: 0.16),    // 銀
        UIColor(hex: "34495E", alpha: 0.16),    // 藍
        UIColor(hex: "FF8080", alpha: 0.16)     // 薄赤
    ]
}
