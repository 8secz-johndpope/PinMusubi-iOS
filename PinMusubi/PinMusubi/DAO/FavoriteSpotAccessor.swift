//
//  FavoriteSpotAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseFirestore
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

    /// Firestoreへ登録
    /// - Parameter favoriteSpot: 登録するお気に入りスポット
    /// - Parameter canShare: シェアの可否
    public func addDocument(favoriteSpot: FavoriteSpotEntity) {
        let dataStore = Firestore.firestore()
        dataStore.collection("favorite_spots").document(favoriteSpot.id).setData(
            [
                "title": favoriteSpot.title,
                "memo": favoriteSpot.memo,
                "rating": favoriteSpot.rating,
                "latitude": favoriteSpot.latitude,
                "longitude": favoriteSpot.longitude,
                "canShare": favoriteSpot.canShare,
                "date": favoriteSpot.dateTime
            ]
        ) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    /// Firestoreから削除
    /// - Parameter id: document_id
    public func deleteDocument(id: String) {
        let dataStore = Firestore.firestore()
        dataStore.collection("favorite_spots").document(id).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
