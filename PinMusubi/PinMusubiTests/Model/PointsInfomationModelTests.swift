//
//  PointsInfomationModelTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2019/10/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import XCTest
@testable import PinMusubi

class PointsInfomationModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testCalculateTransferTime_ok() {
        let pointsInfomationModel = PointsInfomationModel()
        let calculateTransferTimeExpectation = expectation(description: "calculateTransferTime")
        let exampleSettingPoint = SettingPointEntity()
        exampleSettingPoint.name = "東京駅"
        exampleSettingPoint.latitude = 35.681236
        exampleSettingPoint.longitude = 139.767125
        
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.710063
        examplePinPoint.longitude = 139.8107
        
        pointsInfomationModel.calculateTransferTime(settingPoint: exampleSettingPoint, pinPoint: examplePinPoint) { transferTime  in
            XCTAssert(transferTime != -1)
            calculateTransferTimeExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetTransferGuide_ok() {
        let pointsInfomationModel = PointsInfomationModel()
        let getTransferGuideExpectation = expectation(description: "transferGuideExpectation")
        let exampleSettingPoint = SettingPointEntity()
        exampleSettingPoint.name = "東京駅"
        exampleSettingPoint.latitude = 35.681236
        exampleSettingPoint.longitude = 139.767125
        
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.710063
        examplePinPoint.longitude = 139.8107
        
        pointsInfomationModel.getTransportationGuide(settingPoint: exampleSettingPoint, pinPoint: examplePinPoint) { responseString, status in
            XCTAssert(status == .success)
            getTransferGuideExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
