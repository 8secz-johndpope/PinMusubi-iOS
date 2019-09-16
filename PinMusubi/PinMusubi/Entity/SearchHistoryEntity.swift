//
//  SearchHistoryEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

@objcMembers
/// 検索履歴
public class SearchHistoryEntity: Object {
    /// 検索ID
    public dynamic var id: String = UUID().uuidString
    /// 中間地点の緯度
    public dynamic var halfwayPointLatitude = CLLocationDegrees()
    /// 中間地点の経度
    public dynamic var halfwayPointLongitude = CLLocationDegrees()
    /// 検索日時
    public dynamic var dateTime = Date()
    /// 設定地点情報
    public var settingPointEntityList = List<SettingPointEntity>()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
