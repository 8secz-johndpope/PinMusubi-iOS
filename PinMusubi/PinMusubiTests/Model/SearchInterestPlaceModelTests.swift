//
//  SearchInterestPlaceModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/10/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
import RealmSwift
@testable import PinMusubi

class SearchInterestPlaceModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }
    
    func testSetSearchHistory_ok() {
        // データの準備
        let searchInterestPlaceModel = SearchInterestPlaceModel()
        var exampleSettingPoints = [SettingPointEntity]()
        let exampleSettingPoint0 = SettingPointEntity()
        let exampleSettingPoint1 = SettingPointEntity()
        exampleSettingPoint0.name = "地点１"
        exampleSettingPoint0.address = "地点県地点市１"
        exampleSettingPoint0.latitude = 30.0
        exampleSettingPoint0.longitude = 130.0
        exampleSettingPoint1.name = "地点２"
        exampleSettingPoint1.address = "地点県地点市２"
        exampleSettingPoint1.latitude = 32.0
        exampleSettingPoint1.longitude = 134.0
        exampleSettingPoints.append(exampleSettingPoint0)
        exampleSettingPoints.append(exampleSettingPoint1)
        var exampleInterestPoint = CLLocationCoordinate2D()
        exampleInterestPoint.latitude = 31.0
        exampleInterestPoint.longitude = 132.0
        
        // 結果
        let isSuccess = searchInterestPlaceModel.setSearchHistory(settingPoints: exampleSettingPoints, interestPoint: exampleInterestPoint)
        XCTAssertEqual(isSuccess, true)
    }
}
