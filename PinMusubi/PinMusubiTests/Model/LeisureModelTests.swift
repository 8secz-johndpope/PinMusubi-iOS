//
//  LeisureModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
@testable import PinMusubi

class LeisureModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testFetchLeisureList_ok() {
        let leisureModel = LeisureModel()
        let fetchExpectation: XCTestExpectation? = self.expectation(description: "fetchHotelList")
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.681236
        examplePinPoint.longitude = 139.701636
        leisureModel.fetchLeisureList(pinPoint: examplePinPoint, completion: { leisures, status in
            XCTAssertEqual(status, .success)
            for leisure in leisures {
                print("😆😆😆😆😆😆😆😆😆😆😆😆")
                print(leisure)
            }
            fetchExpectation?.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
