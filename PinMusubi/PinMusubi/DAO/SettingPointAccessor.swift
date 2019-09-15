//
//  SettingPointAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import RealmSwift

/// 設定地点情報のデータアクセスクラス
public class SettingPointAccessor: AccessorProtcol {
    /// オブジェクトタイプの設定
    public typealias ObjectType = SettingPointEntity

    /// idから対応するデータを取得
    /// - Parameter id: 地点ID
    public func getByID(id: String) -> SettingPointEntity? {
        do {
            let realm = try Realm()
            let models = realm.objects(SettingPointEntity.self).filter("id = %@", id)
            if !models.isEmpty {
                return models[0]
            }
        } catch {
            print("\n--Error! SettingPointAccessor#getById")
        }
        return nil
    }

    /// 全件検索
    public func getAll() -> Results<SettingPointEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(SettingPointEntity.self)
        } catch {
            print("\n--Error! SettingPointAccessor#getAll")
        }
        return nil
    }
}
