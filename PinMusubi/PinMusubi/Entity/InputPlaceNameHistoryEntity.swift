//
//  InputAddressHistory.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

@objcMembers
public class InputPlaceNameHistoryEntity: Object {
    /// 履歴ID
    public dynamic var id: String = UUID().uuidString
    /// 場所の名前
    public dynamic var title: String = ""
    /// 付加情報
    public dynamic var subTitle: String = ""
    /// 入力日時
    public dynamic var dateTime = Date()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "id"
    }
}
