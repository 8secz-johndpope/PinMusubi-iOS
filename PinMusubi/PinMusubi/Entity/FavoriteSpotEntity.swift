//
//  FavoriteSpotEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

@objcMembers
/// お気に入りスポット
public class FavoriteSpotEntity: Object, MyDataEntityProtocol {
    /// 登録ID
    public dynamic var id: String = UUID().uuidString
    /// お気に入り度
    public dynamic var rating: Double = 0.0
    /// お気に入りタイトル
    public dynamic var title: String = ""
    /// メモ
    public dynamic var memo: String = ""
    /// お気に入り地点の緯度
    public dynamic var latitude = CLLocationDegrees()
    /// お気に入り地点の経度
    public dynamic var longitude = CLLocationDegrees()
    /// 登録日時
    public dynamic var dateTime = Date()
    /// 設定地点情報
    public var settingPointEntityList = List<SettingPointEntity>()
    /// シェアの可否
    public var canShare = false

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
