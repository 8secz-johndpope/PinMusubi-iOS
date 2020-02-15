//
//  PointInfomationEntity.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/15.
//  Copyright © 2020 naipaka. All rights reserved.
//

/// 地点間の情報
internal class PointInfomationEntity {
    /// 移動時間
    internal private(set) var travelTime: Int

    /// 乗換案内ページのURL文字列
    internal private(set) var transferGuideURLString: String

    /// 出発駅
    internal private(set) var fromStationName: String

    /// 到着駅
    internal private(set) var toStationName: String

    /// 乗換案内情報取得結果
    internal private(set) var transferGuideResponseStatus: ResponseStatus

    /// コンストラクタ
    /// - Parameters:
    ///   - travelTime: 移動時間
    ///   - transferGuideURLString: 乗換案内ページのURL文字列
    ///   - fromStationName: 出発駅
    ///   - toStationName: 到着駅
    ///   - transferGuideResponseStatus: 乗換案内情報取得結果
    internal init(travelTime: Int, transferGuideURLString: String, fromStationName: String, toStationName: String, transferGuideResponseStatus: ResponseStatus) {
        self.travelTime = travelTime
        self.transferGuideURLString = transferGuideURLString
        self.fromStationName = fromStationName
        self.toStationName = toStationName
        self.transferGuideResponseStatus = transferGuideResponseStatus
    }
}
