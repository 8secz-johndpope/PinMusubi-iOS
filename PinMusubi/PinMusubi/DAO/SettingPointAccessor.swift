//
//  SettingPointAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import RealmSwift

public class SettingPointAccessor: AccessorProtcol {
    public typealias ObjectType = SettingPointEntity

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
