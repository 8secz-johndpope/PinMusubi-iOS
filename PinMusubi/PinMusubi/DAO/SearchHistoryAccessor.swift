//
//  SearchHistoryAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// 検索履歴のデータアクセスクラス
public class SearchHistoryAccessor: AccessorProtcol {
    /// オブジェクトタイプの設定
    public typealias ObjectType = SearchHistoryEntity

    /// idから対応するデータを取得
    /// - Parameter id: 検索ID
    public func getByID(id: String) -> SearchHistoryEntity? {
        do {
            let realm = try Realm()
            let models = realm.objects(SearchHistoryEntity.self).filter("id = %@", id)
            if !models.isEmpty {
                return models[0]
            }
        } catch {
            print("\n--Error! SearchHistoryAccessor#getById")
        }
        return nil
    }

    /// 全件検索
    public func getAll() -> Results<SearchHistoryEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(SearchHistoryEntity.self)
        } catch {
            print("\n--Error! SearchHistoryAccessor#getAll")
        }
        return nil
    }

    /// idをもとにデータを削除
    /// - Parameter id: id
    public func deleteById(id: String) -> Bool {
        do {
            let realm = try Realm()
            let data = realm.objects(SearchHistoryEntity.self).filter("id = %@", id)
            if !data.isEmpty {
                try realm.write {
                    realm.delete(data)
                }
                return true
            }
        } catch {
            print("\n--Error! SearchHistoryAccessor#getById")
        }
        return false
    }
}
