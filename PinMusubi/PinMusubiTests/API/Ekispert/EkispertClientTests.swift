//
//  EkispertClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class EkispertClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testSearchCourse_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSearchCourse_ok")
        let client = EkispertClient()
        let request = EkispertAPI.SearchCourse(
            fromStation: "西船橋",
            toStation: "氏家"
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response.0?.resultSet.resourceURI)
                print(response.0?.resultSet.resourceURI ?? "🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️")
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testHotelDetailSearch_ok_oneResponse() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testHotelDetailSearch_ok_oneResponse")
        let client = EkispertClient()
        let request = EkispertAPI.SearchStation(name: "西船橋")
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response.0?.resultSet.point)
                XCTAssertNil(response.1?.resultSet.point)
                print(response.0?.resultSet.point ?? "🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️")
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testHotelDetailSearch_ok_multiResponse() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testHotelDetailSearch_ok_oneResponse")
        let client = EkispertClient()
        let request = EkispertAPI.SearchStation(name: "赤坂")
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.0?.resultSet.point)
                XCTAssertNotNil(response.1?.resultSet.point)
                print(response.1?.resultSet.point ?? "🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️")
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
