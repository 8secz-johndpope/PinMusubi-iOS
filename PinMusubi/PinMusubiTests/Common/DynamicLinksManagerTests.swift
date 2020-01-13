//
//  DynamicLinksManagerTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/12/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import XCTest
@testable import PinMusubi

class DynamicLinksManagerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testCreateDynamicLink_ok() {
        let createDynamicLinkExpectation = expectation(description: "createDynamicLink")
        DynamicLinksManager().createDynamicLink() { url in
            print(url ?? "取得できなかったよ")
            createDynamicLinkExpectation.fulfill()
        }
        waitForExpectations(timeout: 50, handler: nil)
    }
}
