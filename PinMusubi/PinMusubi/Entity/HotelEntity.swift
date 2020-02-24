//
//  HotelEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct HotelEntity: SpotEntityProtocol {
    let name: String?
    let category: String?
    let thumbnailURLString: String?
    let imageURLString: String?
    let generalImage: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let distance: Double
    let reviewAverage: String?
    let special: String?
    let access: String?
    let address: String?
    let phoneNumber: String?
    let url: URL?
}
