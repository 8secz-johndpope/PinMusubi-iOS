//
//  InputHistoryEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import RealmSwift

@objcMembers
/// 入力履歴
public class InputHistoryEntity: Object {
    /// ID
    public dynamic var id: String = UUID().uuidString
    /// タイトル
    public dynamic var title: String = ""
    /// サブタイトル
    public dynamic var subtitle: String = ""
    /// 緯度
    public dynamic var latitude = CLLocationDegrees()
    /// 経度
    public dynamic var longitude = CLLocationDegrees()
    /// 検索日付
    public dynamic var dateTime = Date()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
