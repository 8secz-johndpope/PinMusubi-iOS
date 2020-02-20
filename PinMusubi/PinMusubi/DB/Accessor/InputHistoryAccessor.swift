//
//  InputHistoryAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// 検索履歴のデータアクセスクラス
public class InputHistoryAccessor: AccessorProtcol {
    /// オブジェクトタイプの設定
    public typealias ObjectType = InputHistoryEntity

    public func set(data: ObjectType) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                data.dateTime = Date()
                realm.add(data, update: .all)
            }
            return true
        } catch {
            print("\n--Error! Accessor#set")
        }
        return false
    }

    /// idから対応するデータを取得
    /// - Parameter id: 検索ID
    public func getByID(id: String) -> InputHistoryEntity? {
        do {
            let realm = try Realm()
            let models = realm.objects(InputHistoryEntity.self).filter("id = %@", id)
            if !models.isEmpty {
                return models[0]
            }
        } catch {
            print("\n--Error! InputHistoryAccessor#getById")
        }
        return nil
    }

    /// 全件検索
    public func getAll() -> Results<InputHistoryEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(InputHistoryEntity.self).sorted(byKeyPath: "dateTime", ascending: false)
        } catch {
            print("\n--Error! InputHistoryAccessor#getAll")
        }
        return nil
    }
}
