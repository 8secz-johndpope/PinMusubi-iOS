//
//  SettingBasePointsViewDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 基準となる地点を設定するViewのDelegate
public protocol SettingBasePointsViewDelegate: AnyObject {
    /// MapViewに設定地点を描写
    /// - Parameter settingPoints: 設定地点リスト
    /// - Parameter halfwayPoint: 中間地点
    func setPin(settingPoints: [SettingPointEntity], halfwayPoint: CLLocationCoordinate2D)

    /// モーダルを最大にする
    func moveModalToFull()
}
