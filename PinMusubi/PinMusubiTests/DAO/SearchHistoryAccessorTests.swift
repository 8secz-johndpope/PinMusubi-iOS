//
//  SearchHistoryAccessorTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/09/16.
//  Copyright © 2019 naipaka. All rights reserved.
//

import XCTest
import RealmSwift
@testable import PinMusubi

class SearchHistoryAccessorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testSet_ok() {
        let settingPointList = List<SettingPointEntity>()
        for _ in 0...2 {
            let settingPointEntity = SettingPointEntity()
            settingPointEntity.name = "東京駅"
            settingPointEntity.address = "東京都千代田区丸の内１丁目"
            settingPointEntity.latitude = 35.681236
            settingPointEntity.longitude = 139.767125
            settingPointList.append(settingPointEntity)
        }
        
        let searchHistoryEntity = SearchHistoryEntity()
        searchHistoryEntity.halfwayPointLatitude = 35.681236
        searchHistoryEntity.halfwayPointLongitude = 139.767125
        searchHistoryEntity.settingPointEntityList = settingPointList
        
        if SearchHistoryAccessor().set(data: searchHistoryEntity) {
            let realm = try! Realm()
            let savedObject = realm.objects(SearchHistoryEntity.self).first
            XCTAssertEqual(searchHistoryEntity.id, savedObject?.id)
            XCTAssertEqual(searchHistoryEntity.halfwayPointLatitude, savedObject?.halfwayPointLatitude)
            XCTAssertEqual(searchHistoryEntity.halfwayPointLongitude, savedObject?.halfwayPointLongitude)
            XCTAssertEqual(searchHistoryEntity.dateTime, savedObject?.dateTime)
        } else {
            print("Error!")
        }
    }
    
    func testDelete_ok() {
        let realm = try! Realm()
        let exampleSearchHistory = preparationData(realm: realm)
        XCTAssertEqual(realm.objects(SearchHistoryEntity.self).first, exampleSearchHistory)
        
        if SearchHistoryAccessor().delete(data: exampleSearchHistory) {
            XCTAssertNil(realm.objects(SearchHistoryEntity.self).first)
        } else {
            print("Error!")
        }
    }
    
    func testDeleteAll_ok() {
        let realm = try! Realm()
        _ = preparationDataList(realm: realm)
        XCTAssertEqual(realm.objects(SearchHistoryEntity.self).count, 3)
        
        SearchHistoryAccessor().deleteAll()
        XCTAssertEqual(realm.objects(SearchHistoryEntity.self).count, 0)
    }
    
    func testGetById_ok() {
        let realm = try! Realm()
        let exampleSearchHistory = preparationData(realm: realm)
        let searchHistory = SearchHistoryAccessor().getByID(id: exampleSearchHistory.id)
        XCTAssertEqual(searchHistory, exampleSearchHistory)
    }
    
    func testGetAll_ok() {
        let realm = try! Realm()
        let exampleSearchHistoryList = preparationDataList(realm: realm)
        var searchHistoryList = [SearchHistoryEntity]()
        guard let result = SearchHistoryAccessor().getAll() else { return }
        for searchHistory in result {
            searchHistoryList.append(searchHistory)
        }
        XCTAssertEqual(searchHistoryList, exampleSearchHistoryList)
    }
    
    /// テストデータの準備
    func preparationData(realm: Realm) -> SearchHistoryEntity{
        let settingPointList = List<SettingPointEntity>()
        for _ in 0...2 {
            let settingPointEntity = SettingPointEntity()
            settingPointEntity.name = "東京駅"
            settingPointEntity.address = "東京都千代田区丸の内１丁目"
            settingPointEntity.latitude = 35.681236
            settingPointEntity.longitude = 139.767125
            settingPointList.append(settingPointEntity)
        }
        
        let searchHistoryEntity = SearchHistoryEntity()
        searchHistoryEntity.halfwayPointLatitude = 35.681236
        searchHistoryEntity.halfwayPointLongitude = 139.767125
        searchHistoryEntity.settingPointEntityList = settingPointList
        realm.beginWrite()
        realm.add(searchHistoryEntity)
        try! realm.commitWrite()
        return searchHistoryEntity
    }
    
    /// テストデータリストの準備
    func preparationDataList(realm: Realm) -> [SearchHistoryEntity] {
        let settingPointList = List<SettingPointEntity>()
        for _ in 0...2 {
            let settingPointEntity = SettingPointEntity()
            settingPointEntity.name = "東京駅"
            settingPointEntity.address = "東京都千代田区丸の内１丁目"
            settingPointEntity.latitude = 35.681236
            settingPointEntity.longitude = 139.767125
            settingPointList.append(settingPointEntity)
        }
        
        let searchHistoryEntity1 = SearchHistoryEntity()
        searchHistoryEntity1.halfwayPointLatitude = 35.681236
        searchHistoryEntity1.halfwayPointLongitude = 139.767125
        searchHistoryEntity1.settingPointEntityList = settingPointList
        
        let searchHistoryEntity2 = SearchHistoryEntity()
        searchHistoryEntity2.halfwayPointLatitude = 35.681236
        searchHistoryEntity2.halfwayPointLongitude = 139.767125
        searchHistoryEntity2.settingPointEntityList = settingPointList
        
        let searchHistoryEntity3 = SearchHistoryEntity()
        searchHistoryEntity2.halfwayPointLatitude = 35.681236
        searchHistoryEntity2.halfwayPointLongitude = 139.767125
        searchHistoryEntity2.settingPointEntityList = settingPointList
        
        realm.beginWrite()
        realm.add(searchHistoryEntity1)
        realm.add(searchHistoryEntity2)
        realm.add(searchHistoryEntity3)
        try! realm.commitWrite()
        
        var searchHistoryEntityList = [SearchHistoryEntity]()
        searchHistoryEntityList.append(searchHistoryEntity1)
        searchHistoryEntityList.append(searchHistoryEntity2)
        searchHistoryEntityList.append(searchHistoryEntity3)
        return searchHistoryEntityList
    }
}
