//
//  SpotListAnalyticsEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// FirebaseAnalyticsに用いるパラメータのエンティティ
public class SpotListAnalyticsEntity {
    /// 飲食店スポットの数
    public var numRestaurantSpot = 0
    /// 宿泊施設スポットの数
    public var numHotelSpot = 0
    /// レジャースポットの数
    public var numLeisureSpot = 0
    /// 駅・バス停スポットの数
    public var numStationSpot = 0
    /// 飲食店スポットをタップした回数
    public var timesTappedRestaurantSpot = 0
    /// 宿泊施設スポットをタップした回数
    public var timesTappedHotelSpot = 0
    /// レジャースポットをタップした回数
    public var timesTappedLeisureSpot = 0
    /// 駅・バス停スポットをタップした回数
    public var timesTappedStationSpot = 0
}
