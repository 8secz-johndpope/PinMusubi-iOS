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
    func setPin(settingPoints: [SettingPointEntity], halfwayPoint: CLLocationCoordinate2D)

    func moveModalToFull()

    func showSearchCompleterView(inputEditingCell: SettingBasePointCell)
}
