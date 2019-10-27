//
//  StationModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
@testable import PinMusubi

class StationModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testFetchStationList_ok() {
        let stationModel = StationModel()
        let fetchExpectation: XCTestExpectation? = self.expectation(description: "fetchStationList")
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.681236
        examplePinPoint.longitude = 139.701636
        stationModel.fetchStationList(pinPoint: examplePinPoint, completion: { stations, status in
            XCTAssertEqual(status, ResponseStatus.success)
            for station in stations {
                print("😆😆😆😆😆😆😆😆😆😆😆😆")
                print(station)
            }
            fetchExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
