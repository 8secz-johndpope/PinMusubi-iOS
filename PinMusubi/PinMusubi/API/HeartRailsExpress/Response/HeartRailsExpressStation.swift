//
//  HeartRailsExpressStation.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

// MARK: - HeartRailsExpressStation
struct HeartRailsExpressStation: Decodable {
    let name: String
    let prefecture: String
    let line: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let postal: String
    let distance: String
    let prev: String?
    let next: String?

    enum CodingKeys: String, CodingKey {
        case name
        case prefecture
        case line
        case latitude = "y"
        case longitude = "x"
        case postal
        case distance
        case prev
        case next
    }
}
