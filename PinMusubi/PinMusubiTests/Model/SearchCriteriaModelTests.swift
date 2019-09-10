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
    
    var searchCriteriaModel: SearchCriteriaModel!
    
    override func setUp() {
        super.setUp()
        self.searchCriteriaModel = SearchCriteriaModel()
    }
    
    func testSetPointName_ok_validPointName() {
        let exampleName = "自分の家"
        let exampleRow = 0
        searchCriteriaModel.setPointName(name: exampleName, row: exampleRow)
        XCTAssertEqual(searchCriteriaModel.settingPoints[0].name, exampleName)
    }
    
    func testGeocoding_ok_validAddress() {
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleAddress = "東京都千代田区丸の内1丁目"
        let exampleRow = 0
        searchCriteriaModel.geocoding(address: exampleAddress, row: exampleRow, complete:{
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].address, exampleAddress)
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].latitude, 35.67969030795562)
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].longitude, 139.76127710643334)
            geocodingExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGeocoding_ng_invalidAddress() {
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleAddress = "無効な住所"
        let exampleRow = 0
        searchCriteriaModel.geocoding(address: exampleAddress, row: exampleRow, complete:{
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].address, "")
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].latitude, CLLocationDegrees())
            XCTAssertEqual(self.searchCriteriaModel.settingPoints[0].longitude, CLLocationDegrees())
            geocodingExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}

