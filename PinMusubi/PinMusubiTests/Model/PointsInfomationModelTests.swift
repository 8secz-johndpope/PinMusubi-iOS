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
        var exampleSettingPoints = [SettingPointEntity]()
        let exampleSettingPoint0 = SettingPointEntity()
        let exampleSettingPoint1 = SettingPointEntity()
        exampleSettingPoint0.name = "東京駅"
        exampleSettingPoint0.latitude = 35.681236
        exampleSettingPoint0.longitude = 139.767125
        exampleSettingPoint1.name = "渋谷駅"
        exampleSettingPoint1.latitude = 35.658034
        exampleSettingPoint1.longitude = 139.701636
        exampleSettingPoints.append(exampleSettingPoint0)
        exampleSettingPoints.append(exampleSettingPoint1)
        var examplePinPoint = CLLocationCoordinate2D()
        examplePinPoint.latitude = 35.710063
        examplePinPoint.longitude = 139.8107
        
        pointsInfomationModel.calculateTransferTime(settingPoints: exampleSettingPoints, pinPoint: examplePinPoint, complete: { pointNames, transferTimes in
            XCTAssert(pointNames.contains(exampleSettingPoint0.name))
            XCTAssert(pointNames.contains(exampleSettingPoint1.name))
            XCTAssert(transferTimes[0] != -1)
            XCTAssert(transferTimes[1] != -1)
            calculateTransferTimeExpectation.fulfill()
        }
        )
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetTransferGuide_ok() {
        let pointsInfomationModel = PointsInfomationModel()
        let getTransferGuideExpectation = expectation(description: "getTransferGuideSuccess")
        let exampleFrom = "西船橋"
        let exampleTo = "新木場"
        
        pointsInfomationModel.getTransferGuide(fromStation: exampleFrom, toStation: exampleTo, complete: {
            responseString, status in
            XCTAssert(status == .success)
            getTransferGuideExpectation.fulfill()
        }
        )
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetTransferGuide_ng() {
        let pointsInfomationModel = PointsInfomationModel()
        let getTransferGuideExpectation = expectation(description: "getTransferGuideError")
        let exampleFrom = "天国"
        let exampleTo = "地獄"
        
        pointsInfomationModel.getTransferGuide(fromStation: exampleFrom, toStation: exampleTo, complete: {
            responseString, status in
            XCTAssert(status == .error)
            getTransferGuideExpectation.fulfill()
        }
        )
        waitForExpectations(timeout: 10, handler: nil)
    }
}
