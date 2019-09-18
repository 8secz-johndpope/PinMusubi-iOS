//
//  TestData.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import MapKit

public class TestData {
    public static func setTestPin() -> ([SettingPointEntity], CLLocationCoordinate2D) {
        let settingPointEntity1 = SettingPointEntity()
        settingPointEntity1.name = "東京駅"
        settingPointEntity1.address = "東京都千代田区丸の内１丁目"
        settingPointEntity1.latitude = 35.681_236
        settingPointEntity1.longitude = 139.767_125

        let settingPointEntity2 = SettingPointEntity()
        settingPointEntity2.name = "新大阪駅"
        settingPointEntity2.address = "大阪府大阪市淀川区西中島五丁目"
        settingPointEntity2.latitude = 34.733_48
        settingPointEntity2.longitude = 135.500_109

        let settingPointEntity3 = SettingPointEntity()
        settingPointEntity3.name = "新潟駅"
        settingPointEntity3.address = "新潟県新潟市中央区花園１丁目１−１"
        settingPointEntity3.latitude = 37.912_027
        settingPointEntity3.longitude = 139.061_883

        var settingPointEntityList = [SettingPointEntity]()
        settingPointEntityList.append(settingPointEntity1)
        settingPointEntityList.append(settingPointEntity2)
        settingPointEntityList.append(settingPointEntity3)
        let halfwayPoint = CLLocationCoordinate2D(latitude: 36.000_229, longitude: 137.340_087)

        return (settingPointEntityList, halfwayPoint)
    }
}
