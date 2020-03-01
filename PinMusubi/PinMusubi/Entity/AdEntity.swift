//
//  AdEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/16.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct AdEntity: SpotEntityProtocol {
    var name: String = "Ad"
    var category: String = "Ad"
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var distance: Double = 0.0
}
