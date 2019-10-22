//
//  BusStopEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public struct BusStopEntity: Codable {
    public var busStop: [BusStop]
}

public struct BusStop: Codable {
    public var busLineName: String
    public var busOperationCompany: String
    public var busStopName: String
    public var busType: String
    public var distance: Double
    public var location: [CLLocationDegrees]
}
