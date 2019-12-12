//
//  InputHistoryEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

@objcMembers
/// お気に入りスポット
public class InputHistoryEntity: Object, MyDataEntityProtocol {
    /// 検索キーワード
    public dynamic var keyword: String = ""
    /// 検索日付
    public dynamic var dateTime = Date()

    /// プライマリキーの設定
    override public static func primaryKey() -> String? {
        return "keyword"
    }
}
