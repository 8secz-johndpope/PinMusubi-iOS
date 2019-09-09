//
//  SearchCriteriaModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
@testable import PinMusubi

class SearchCriteriaModelTests: XCTestCase {
    
    func testSetPointName_ok_validPointName() {
        let searchCriteriaModel = SearchCriteriaModel()
        let testName = "自分の家"
        let testRow = 0
        searchCriteriaModel.setPointName(name: testName, row: testRow)
        XCTAssertEqual(searchCriteriaModel.settingPoints[0].name, testName)
    }
    
    func testGeocoding_ok_validAddress() {
        let searchCriteriaModel = SearchCriteriaModel()
        let testAddress = "東京都千代田区丸の内1丁目"
        let testRow = 0
        self.expectation(forNotification: NSNotification.Name(rawValue: "geocording"), object: nil) { (notification) -> Bool in
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].address, testAddress)
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].latitude, 35.67969030795562)
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].longitude, 139.76127710643334)
            return true
        }
        searchCriteriaModel.geocoding(address: testAddress, row: testRow)
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGeocoding_ng_invalidAddress() {
        let searchCriteriaModel = SearchCriteriaModel()
        let testAddress = "無効な住所"
        let testRow = 0
        self.expectation(forNotification: NSNotification.Name(rawValue: "geocording"), object: nil) { (notification) -> Bool in
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].address, "")
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].latitude, CLLocationDegrees())
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].longitude, CLLocationDegrees())
            return true
        }
        searchCriteriaModel.geocoding(address: testAddress, row: testRow)
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}

