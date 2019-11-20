//
//  HotelModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
@testable import PinMusubi

class HotelModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testFetchHotelList_ok() {
        let hotelModel = HotelModel()
        let fetchExpectation: XCTestExpectation? = self.expectation(description: "fetchHotelList")
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.681236
        examplePinPoint.longitude = 139.701636
        hotelModel.fetchHotelList(pinPoint: examplePinPoint, completion: { hotels, status in
            XCTAssertEqual(status, .success)
            for hotel in hotels {
                print("😆😆😆😆😆😆😆😆😆😆😆😆")
                print(hotel)
            }
            fetchExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
