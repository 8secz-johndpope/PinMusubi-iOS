//
//  EkispertPoint.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertPoint
struct EkispertPoint: Decodable {
    let station: EkispertStation
    let geoPoint: EkispertGeoPoint
    let prefecture: EkispertPrefecture

    enum CodingKeys: String, CodingKey {
        case station = "Station"
        case geoPoint = "GeoPoint"
        case prefecture = "Prefecture"
    }
}
