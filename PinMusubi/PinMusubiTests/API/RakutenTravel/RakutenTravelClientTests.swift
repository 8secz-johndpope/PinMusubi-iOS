//
//  RakutenTravelClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class RakutenTravelClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testSimpleHotelSearch_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSimpleHotelSearch_ok")
        let client = RakutenTravelClient()
        let request = RakutenTravelAPI.SimpleHotelSearch(
            latitude: "37.912027",
            longitude: "139.061883",
            searchRadius: RakutenTravelRequestParameter.SearchRadius.range3000.rawValue,
            squeezeCondition: nil
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response.hotels)
                
                for hotel in response.hotels {
                    print(hotel)
                }
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSimpleHotelSearch_parameterError() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSimpleHotelSearch_parameterError")
        let client = RakutenTravelClient()
        let request = RakutenTravelAPI.SimpleHotelSearch(
            latitude: nil,
            longitude: nil,
            searchRadius: nil,
            squeezeCondition: nil
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.hotels)
                
                for hotel in response.hotels {
                    print(hotel)
                }
            case let .failure(error):
                print(error)
                XCTAssertNotNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
