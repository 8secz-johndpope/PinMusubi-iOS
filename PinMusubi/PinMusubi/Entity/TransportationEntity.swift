//
//  TransportationEntity.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/01.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

struct TransportationEntity: SpotEntityProtocol {
    var name: String
    var category: String
    let image: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var distance: Double
    let address: String?
    let url: URL?
}
