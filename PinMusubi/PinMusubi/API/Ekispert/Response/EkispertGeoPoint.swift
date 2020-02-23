//
//  EkispertGeoPoint.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertGeoPoint
struct EkispertGeoPoint: Decodable {
    let longi, lati, longiD, latiD: String
    let gcs: String

    enum CodingKeys: String, CodingKey {
        case longi, lati
        case longiD = "longi_d"
        case latiD = "lati_d"
        case gcs
    }
}
