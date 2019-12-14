//
//  FavoriteInputWrapperAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// 登録地点のデータアクセスクラス
public class FavoriteInputWrapperAccessor {
    /// 全件検索
    public func getAll() -> List<FavoriteInputEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList
        } catch {
            print("\n--Error! FavoriteInputAccessor#getAll")
        }
        return nil
    }

    ///  登録
    public func set(object: FavoriteInputEntity) {
        do {
            let realm = try Realm()
            try realm.write {
                if realm.objects(FavoriteInputWrapper.self).first == nil {
                    realm.add(FavoriteInputWrapper())
                }
                let objects = realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList
                objects?.insert(object, at: 0)
            }
        } catch {
            print("\n--Error! FavoriteInputAccessor#set")
        }
    }

    /// 削除
    public func delete(object: FavoriteInputEntity) {
        do {
            let realm = try Realm()
            try realm.write {
                let objects = realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList
                guard let index = objects?.index(of: object) else { return }
                objects?.remove(at: index)
            }
        } catch {
            print("\n--Error! Accessor#delete")
        }
    }

    /// 順序入れ替え
    public func replaceRow(sourceRow: Int, destinationRow: Int) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let sourceObject = realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList[sourceRow] else { return }
                realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList.remove(at: sourceRow)
                realm.objects(FavoriteInputWrapper.self).first?.favoriteInputList.insert(sourceObject, at: destinationRow)
            }
        } catch {
            print("\n--Error! FavoriteInputAccessor#replaceRow")
        }
    }
}
