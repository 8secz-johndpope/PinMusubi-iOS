//
//  SettingBasePointsModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import XCTest
@testable import PinMusubi

class SettingBasePointsModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testGeocoding_ok_validAddress() {
        let settingBasePointsModel = SettingBasePointsModel()
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleCompletion = MKLocalSearchCompletion()
        settingBasePointsModel.geocode(completion: exampleCompletion) { coordinate in
            geocodingExpectation?.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGeocoding_ng_invalidAddress() {
        let settingBasePointsModel = SettingBasePointsModel()
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleCompletion = MKLocalSearchCompletion()
        settingBasePointsModel.geocode(completion: exampleCompletion) { coordinate in
            XCTAssertNil(coordinate)
            geocodingExpectation?.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCalculateHalfPoint_ok() {
        let settingBasePointsModel = SettingBasePointsModel()
        var exampleSettingPoints = [SettingPointEntity]()
        let exampleSettingPoint0 = SettingPointEntity()
        let exampleSettingPoint1 = SettingPointEntity()
        exampleSettingPoint0.latitude = 30.0
        exampleSettingPoint0.longitude = 130.0
        exampleSettingPoint1.latitude = 32.0
        exampleSettingPoint1.longitude = 134.0
        exampleSettingPoints.append(exampleSettingPoint0)
        exampleSettingPoints.append(exampleSettingPoint1)
        
        let resultHalfPoint = settingBasePointsModel.calculateHalfPoint(settingPoints: exampleSettingPoints)
        XCTAssertEqual(resultHalfPoint.latitude, 31.0)
        XCTAssertEqual(resultHalfPoint.longitude, 132.0)
    }
}

