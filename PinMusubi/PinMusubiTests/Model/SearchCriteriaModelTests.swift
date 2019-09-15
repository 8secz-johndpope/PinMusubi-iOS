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
    override func setUp() {
        super.setUp()
    }
    
    func testSetPointName_ok_validPointName() {
        let searchCriteriaModel = SearchCriteriaModel()
        let exampleName = "自分の家"
        searchCriteriaModel.setPointName(name: exampleName, row: 0)
        XCTAssertEqual(searchCriteriaModel.settingPoints[0].name, exampleName)
    }
    
    func testGeocoding_ok_validAddress() {
        let searchCriteriaModel = SearchCriteriaModel()
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleAddress = "東京都千代田区丸の内1丁目"
        searchCriteriaModel.geocoding(address: exampleAddress, row: 0, complete:{
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].address, exampleAddress)
            print(searchCriteriaModel.settingPoints[0].latitude)
            print(searchCriteriaModel.settingPoints[0].longitude)
            geocodingExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGeocoding_ng_invalidAddress() {
        let searchCriteriaModel = SearchCriteriaModel()
        let geocodingExpectation: XCTestExpectation? = self.expectation(description: "geocoding")
        let exampleAddress = "無効な住所"
        searchCriteriaModel.geocoding(address: exampleAddress, row: 0, complete:{
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].address, "")
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].latitude, CLLocationDegrees())
            XCTAssertEqual(searchCriteriaModel.settingPoints[0].longitude, CLLocationDegrees())
            geocodingExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCalculateHalfPoint_ok_2points() {
        let searchCriteriaModel = SearchCriteriaModel()
        let calculateHalfPointExpectation: XCTestExpectation? = self.expectation(description: "calculateHalfPoint")
        let exampleAddress0 = "東京都千代田区丸の内1丁目"
        let exampleAddress1 = "大阪府大阪市北区梅田３丁目１−１"
        searchCriteriaModel.geocoding(address: exampleAddress0, row: 0, complete: {
            searchCriteriaModel.geocoding(address: exampleAddress1, row: 1, complete: {
                let halfPoint = searchCriteriaModel.calculateHalfPoint()
                print(halfPoint)
                calculateHalfPointExpectation?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCalculateHalfPoint_ok_3points() {
        let searchCriteriaModel = SearchCriteriaModel()
        let calculateHalfPointExpectation: XCTestExpectation? = self.expectation(description: "calculateHalfPoint")
        let exampleAddress0 = "東京都千代田区丸の内1丁目"
        let exampleAddress1 = "大阪府大阪市北区梅田３丁目１−１"
        let exampleAddress2 = "920-0858"
        searchCriteriaModel.geocoding(address: exampleAddress0, row: 0, complete: {
            searchCriteriaModel.geocoding(address: exampleAddress1, row: 1, complete: {
                searchCriteriaModel.geocoding(address: exampleAddress2, row: 2, complete: {
                    let halfPoint = searchCriteriaModel.calculateHalfPoint()
                    print(halfPoint)
                    calculateHalfPointExpectation?.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCalculateHalfPoint_ok_10points() {
        let searchCriteriaModel = SearchCriteriaModel()
        let calculateHalfPointExpectation: XCTestExpectation? = self.expectation(description: "calculateHalfPoint")
        let exampleAddress0 = "東京都千代田区丸の内1丁目"
        let exampleAddress1 = "大阪府大阪市北区梅田３丁目１−１"
        let exampleAddress2 = "920-0858"
        let exampleAddress3 = "北海道札幌市北区北６条西４丁目"
        let exampleAddress4 = "沖縄県那覇市字鏡水１５０"
        let exampleAddress5 = "950-0086"
        let exampleAddress6 = "812-0003"
        let exampleAddress7 = "980-0021"
        let exampleAddress8 = "愛知県名古屋市中村区名駅１丁目１−４"
        let exampleAddress9 = "京都府京都市下京区東塩小路釜殿町"
        searchCriteriaModel.geocoding(address: exampleAddress0, row: 0, complete: {
            searchCriteriaModel.geocoding(address: exampleAddress1, row: 1, complete: {
                searchCriteriaModel.geocoding(address: exampleAddress2, row: 2, complete: {
                    searchCriteriaModel.geocoding(address: exampleAddress3, row: 3, complete: {
                        searchCriteriaModel.geocoding(address: exampleAddress4, row: 4, complete: {
                            searchCriteriaModel.geocoding(address: exampleAddress5, row: 5, complete: {
                                searchCriteriaModel.geocoding(address: exampleAddress6, row: 6, complete: {
                                    searchCriteriaModel.geocoding(address: exampleAddress7, row: 7, complete: {
                                        searchCriteriaModel.geocoding(address: exampleAddress8, row: 8, complete: {
                                            searchCriteriaModel.geocoding(address: exampleAddress9, row: 9, complete: {
                                                let halfPoint = searchCriteriaModel.calculateHalfPoint()
                                                print(halfPoint)
                                                calculateHalfPointExpectation?.fulfill()
                                            })
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}

