//
//  BusStopResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

struct BusStopResponse: Decodable {
    let busLineName: String
    let busOperationCompany: String
    let busStopName: String
    let busType: String
    let distance: Double
    let location: [CLLocationDegrees]
}
