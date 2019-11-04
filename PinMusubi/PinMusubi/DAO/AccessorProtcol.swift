//
//  AccessorProtcol.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import RealmSwift

/// アクセスクラスのプロトコル
public protocol AccessorProtcol {
    /// アクセスするオブジェクトのタイプ
    associatedtype ObjectType: Object
    /// idからデータを１件取得
    func getByID(id: String) -> ObjectType?
    /// データを全件取得
    func getAll() -> Results<ObjectType>?
}

/// アクセスクラスで共通するメソッドを定義した拡張プロトコル
public extension AccessorProtcol {
    /// データを登録（すでにプライマリーキーが存在していれば更新）
    /// - Parameter data: 追加したデータ
    func set(data: Object) -> Bool {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            try realm.write {
                realm.add(data, update: .all)
            }
            return true
        } catch {
            print("\n--Error! Accessor#set")
        }
        return false
    }

    /// 対象のデータを削除
    /// - Parameter data: 削除したいデータ
    func delete(data: Object) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(data)
            }
            return true
        } catch {
            print("\n--Error! Accessor#delete")
        }
        return false
    }

    /// データを全削除
    func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("\n--Error! Accessor#delete")
        }
    }
}
