//
//  FavoriteSpotAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// お気に入りスポットのデータアクセスクラス
public class FavoriteSpotAccessor: AccessorProtcol {
    /// オブジェクトタイプの設定
    public typealias ObjectType = FavoriteSpotEntity

    /// idから対応するデータを取得
    /// - Parameter id: ID
    public func getByID(id: String) -> FavoriteSpotEntity? {
        do {
            let realm = try Realm()
            let models = realm.objects(FavoriteSpotEntity.self).filter("id = %@", id)
            if !models.isEmpty {
                return models[0]
            }
        } catch {
            print("\n--Error! FavoriteSpotAccessor#getById")
        }
        return nil
    }

    /// 全件検索
    public func getAll() -> Results<FavoriteSpotEntity>? {
        do {
            let realm = try Realm()

            return realm.objects(FavoriteSpotEntity.self)
        } catch {
            print("\n--Error! FavoriteSpotAccessor#getAll")
        }
        return nil
    }

    /// idをもとにデータを削除
    /// - Parameter id: id
    public func deleteById(id: String) -> Bool {
        do {
            let realm = try Realm()
            let data = realm.objects(FavoriteSpotEntity.self).filter("id = %@", id)
            if !data.isEmpty {
                try realm.write {
                    realm.delete(data)
                }
                return true
            }
        } catch {
            print("\n--Error! FavoriteSpotAccessor#getById")
        }
        return false
    }
}
