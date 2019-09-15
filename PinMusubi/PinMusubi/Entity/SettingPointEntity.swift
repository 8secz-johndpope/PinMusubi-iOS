//
//  SearchCriteria.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

@objcMembers
/// 設定地点情報
public class SettingPointEntity: Object {
    /// 地点ID
    public dynamic var id: String = UUID().uuidString
    /// 地点の名前
    public dynamic var name: String = ""
    /// 住所情報
    public dynamic var address: String = ""
    /// 緯度
    public dynamic var latitude = CLLocationDegrees()
    /// 経度
    public dynamic var longitude = CLLocationDegrees()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
