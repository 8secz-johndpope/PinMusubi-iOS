//
//  RestaurantEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct RestaurantEntity: SpotEntityProtocol {
    let name: String?
    let category: String?
    let imageURLString: String?
    let generalImage: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let distance: Double
    let price: String?
    let access: String?
    let address: String?
    let open: String?
    let close: String?
    let phoneNumber: String?
    let url: URL?
}
