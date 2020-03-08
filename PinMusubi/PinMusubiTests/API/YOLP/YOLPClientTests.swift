//
//  YOLPClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class YOLPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testLocalSearch_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSimpleHotelSearch_ok")
        let client = YOLPClient()
        let request = YOLPAPI.LocalSearch(
            query: nil,
            id: nil,
            sort: YOLPRequestParameter.Sort.dist.rawValue,
            results: YOLPRequestParameter.Results.result100.rawValue,
            latitude: "37.912027",
            longitude: "139.061883",
            dist: YOLPRequestParameter.Dist.dist3000.rawValue,
            gc: YOLPRequestParameter.GC.Leisure.allCases.reduce("") { $0 + "," + $1.rawValue }
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNotNil(response.feature)
                
                for feature in response.feature! {
                    print(feature)
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
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSimpleHotelSearch_ok")
        let client = YOLPClient()
        let request = YOLPAPI.LocalSearch(
            query: nil,
            id: nil,
            sort: nil,
            results: nil,
            latitude: nil,
            longitude: nil,
            dist: nil,
            gc: nil
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.feature)
            case let .failure(error):
                print(error)
                XCTAssertNotNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
