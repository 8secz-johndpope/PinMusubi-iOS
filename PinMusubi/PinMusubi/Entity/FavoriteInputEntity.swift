//
//  FavoriteInputEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import RealmSwift

@objcMembers
/// 登録地点
public class FavoriteInputEntity: Object {
    /// ID
    public dynamic var id: String = UUID().uuidString
    /// お気に入り名称
    public dynamic var name: String = ""
    /// 緯度
    public dynamic var latitude = CLLocationDegrees()
    /// 経度
    public dynamic var longitude = CLLocationDegrees()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
