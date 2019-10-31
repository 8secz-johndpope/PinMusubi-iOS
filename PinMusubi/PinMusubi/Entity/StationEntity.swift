//
//  StationEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public struct StationEntity: Codable {
    public var response: Response
}

public struct Response: Codable {
    public var station: [Station]
}

public struct Station: Codable, SpotEntityProtocol {
    public var name: String
    public var prefecture: String
    public var line: String
    public var lat: CLLocationDegrees
    public var lng: CLLocationDegrees
    public var postal: String
    public var distance: String
    public var prev: String?
    public var next: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case prefecture
        case line
        case lat = "y"
        case lng = "x"
        case postal
        case distance
        case prev
        case next
    }
}
