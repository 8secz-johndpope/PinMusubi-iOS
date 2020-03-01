//
//  RestaurantEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct RestaurantEntity: SpotEntityProtocol {
    var name: String
    var category: String
    let imageURLString: String?
    let generalImage: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var distance: Double
    let price: String?
    let access: String?
    let address: String?
    let open: String?
    let close: String?
    let phoneNumber: String?
    let url: URL?
}
