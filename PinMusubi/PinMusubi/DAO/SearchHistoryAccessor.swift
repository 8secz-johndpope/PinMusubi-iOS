//
//  SearchHistoryAccessor.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import RealmSwift

public class SearchHistoryAccessor: AccessorProtcol {
    public typealias ObjectType = SearchHistoryEntity

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

    public func getAll() -> Results<SearchHistoryEntity>? {
        do {
            let realm = try Realm()
            return realm.objects(SearchHistoryEntity.self)
        } catch {
            print("\n--Error! SearchHistoryAccessor#getAll")
        }
        return nil
    }
}
