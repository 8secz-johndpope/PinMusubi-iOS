//
//  HotpepperClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
import Foundation
@testable import PinMusubi

class HotpepperClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testFetchShop_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testFetchShop_ok")
        let client = HotpepperClient()
        let request = HotpepperAPI.SearchGourmet(
            keyword: nil,
            id: nil,
            latitude: "37.912027",
            longitude: "139.061883",
            range: nil,
            order: nil,
            count: HotpepperRequestParameter.Count.count100.rawValue
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.results.error)
                XCTAssertNotNil(response.results.items)
            case let .failure(error):
                print(error)
                XCTAssertNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchShop_parameterError() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testFetchShop_parameterError")
        let client = HotpepperClient()
        let request = HotpepperAPI.SearchGourmet(
            keyword: nil,
            id: nil,
            latitude: nil,
            longitude: nil,
            range: HotpepperRequestParameter.Range.range3000.rawValue,
            order: nil,
            count: HotpepperRequestParameter.Count.count100.rawValue
        )
        
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                XCTAssertNil(response.results.items)
                XCTAssertNotNil(response.results.error)
                guard let error = response.results.error else { return }
                print(error.message)
            case let .failure(error):
                print(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchShop_connectionError() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testFetchShop_connectionError")
        let client = HotpepperClient()
        let request = HotpepperAPI.SearchGourmet(
            keyword: nil,
            id: nil,
            latitude: nil,
            longitude: nil,
            range: HotpepperRequestParameter.Range.range3000.rawValue,
            order: nil,
            count: HotpepperRequestParameter.Count.count100.rawValue
        )
        
        client.send(request: request) { result in
            switch result {
            case .success(_): break
                
            case let .failure(error):
                XCTAssertNotNil(error)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
