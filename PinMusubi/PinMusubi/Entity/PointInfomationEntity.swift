//
//  PointInfomationEntity.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/15.
//  Copyright © 2020 naipaka. All rights reserved.
//

/// 地点間の情報
class PointInfomationEntity {
    /// 徒歩移動時間
    var walkTime: Int?

    /// 自転車移動時間
    var bicycleTime: Int?

    /// 車移動時間
    var carTime: Int?

    /// 乗換案内ページのURL文字列
    var transferGuideURLString: String = ""

    /// 出発駅
    var fromStationName: String = ""

    /// 到着駅
    var toStationName: String = ""
}
