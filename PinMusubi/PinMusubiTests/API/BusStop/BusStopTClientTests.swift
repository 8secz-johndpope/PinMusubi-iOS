//
//  BusStopTClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class BusStopTClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testGetBusStop_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testGetBusStop_ok")
        let client = BusStopClient()
        let request = BusStopAPI.GetBusStop(
            latitude: "35.6598051",
            longitude: "139.7036661"
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response)

                response.forEach {
                    print("🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️")
                    print($0)
                }
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLocalSearch_parameterError() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testLocalSearch_parameterError")
        let client = BusStopClient()
        let request = BusStopAPI.GetBusStop(
            latitude: nil,
            longitude: nil
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response)
            case let .failure(error):
                print(error)
                XCTAssertNotNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
