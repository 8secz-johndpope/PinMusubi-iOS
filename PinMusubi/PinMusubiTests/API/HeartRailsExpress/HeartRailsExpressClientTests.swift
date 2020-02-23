//
//  HeartRailsExpressClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class HeartRailsExpressClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testGetStations_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testGetStations_ok")
        let client = HeartRailsExpressClient()
        let request = HeartRailsExpressAPI.GetStations(
            latitude: "37.912027",
            longitude: "139.061883"
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.response.error)
                XCTAssertNotNil(response.response.station)
                
                response.response.station?.forEach { print($0) }
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetStations_parameterError() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testGetStations_parameterError")
        let client = HeartRailsExpressClient()
        let request = HeartRailsExpressAPI.GetStations(
            latitude: nil,
            longitude: nil
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response.response.error)
                XCTAssertNil(response.response.station)
                
                print(response.response.error!)
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
