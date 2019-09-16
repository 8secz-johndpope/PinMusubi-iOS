//
//  SettingPointAccessorTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/09/16.
//  Copyright © 2019 naipaka. All rights reserved.
//

import XCTest
import RealmSwift
@testable import PinMusubi

class SettingPointAccessorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testSet_ok() {
        let settingPointEntity = SettingPointEntity()
        settingPointEntity.name = "東京駅"
        settingPointEntity.address = "東京都千代田区丸の内１丁目"
        settingPointEntity.latitude = 35.681236
        settingPointEntity.longitude = 139.767125
        
        if SettingPointAccessor().set(data: settingPointEntity) {
            let realm = try! Realm()
            let savedObject = realm.objects(SettingPointEntity.self).first
            XCTAssertEqual(settingPointEntity.id, savedObject?.id)
            XCTAssertEqual(settingPointEntity.name, savedObject?.name)
            XCTAssertEqual(settingPointEntity.address, savedObject?.address)
            XCTAssertEqual(settingPointEntity.latitude, savedObject?.latitude)
            XCTAssertEqual(settingPointEntity.longitude, savedObject?.longitude)
        } else {
            print("Error!")
        }
    }
    
    func testDelete_ok() {
        let realm = try! Realm()
        let exampleSettingPoint = preparationData(realm: realm)
        XCTAssertEqual(realm.objects(SettingPointEntity.self).first, exampleSettingPoint)
        
        if SettingPointAccessor().delete(data: exampleSettingPoint) {
            XCTAssertNil(realm.objects(SettingPointEntity.self).first)
        } else {
            print("Error!")
        }
    }
    
    func testDeleteAll_ok() {
        let realm = try! Realm()
        _ = preparationDataList(realm: realm)
        XCTAssertEqual(realm.objects(SettingPointEntity.self).count, 3)
        
        SettingPointAccessor().deleteAll()
        XCTAssertEqual(realm.objects(SettingPointEntity.self).count, 0)
    }
    
    func testGetById_ok() {
        let realm = try! Realm()
        let exampleSettingPoint = preparationData(realm: realm)
        let settingPoint = SettingPointAccessor().getByID(id: exampleSettingPoint.id)
        XCTAssertEqual(settingPoint, exampleSettingPoint)
    }
    
    func testGetAll_ok() {
        let realm = try! Realm()
        let exampleSettingPointList = preparationDataList(realm: realm)
        var settingPointList = [SettingPointEntity]()
        guard let result = SettingPointAccessor().getAll() else { return }
        for settingPoint in result {
            settingPointList.append(settingPoint)
        }
        XCTAssertEqual(settingPointList, exampleSettingPointList)
    }
    
    /// テストデータの準備
    func preparationData(realm: Realm) -> SettingPointEntity{
        let settingPointEntity = SettingPointEntity()
        settingPointEntity.name = "東京駅"
        settingPointEntity.address = "東京都千代田区丸の内１丁目"
        settingPointEntity.latitude = 35.681236
        settingPointEntity.longitude = 139.767125
        realm.beginWrite()
        realm.add(settingPointEntity)
        try! realm.commitWrite()
        return settingPointEntity
    }
    
    /// テストデータリストの準備
    func preparationDataList(realm: Realm) -> [SettingPointEntity] {
        let settingPointEntity1 = SettingPointEntity()
        settingPointEntity1.name = "東京駅"
        settingPointEntity1.address = "東京都千代田区丸の内１丁目"
        settingPointEntity1.latitude = 35.681236
        settingPointEntity1.longitude = 139.767125
        
        let settingPointEntity2 = SettingPointEntity()
        settingPointEntity2.name = "東京駅"
        settingPointEntity2.address = "東京都千代田区丸の内１丁目"
        settingPointEntity2.latitude = 35.681236
        settingPointEntity2.longitude = 139.767125
        
        let settingPointEntity3 = SettingPointEntity()
        settingPointEntity3.name = "東京駅"
        settingPointEntity3.address = "東京都千代田区丸の内１丁目"
        settingPointEntity3.latitude = 35.681236
        settingPointEntity3.longitude = 139.767125
        
        realm.beginWrite()
        realm.add(settingPointEntity1)
        realm.add(settingPointEntity2)
        realm.add(settingPointEntity3)
        try! realm.commitWrite()
        
        var settingPointEntityList = [SettingPointEntity]()
        settingPointEntityList.append(settingPointEntity1)
        settingPointEntityList.append(settingPointEntity2)
        settingPointEntityList.append(settingPointEntity3)
        return settingPointEntityList
    }
}
