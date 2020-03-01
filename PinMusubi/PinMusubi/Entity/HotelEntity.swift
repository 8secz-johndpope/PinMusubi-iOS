//
//  HotelEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct HotelEntity: SpotEntityProtocol {
    var name: String
    var category: String
    let thumbnailURLString: String?
    let imageURLString: String?
    let generalImage: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var distance: Double
    let reviewAverage: String?
    let special: String?
    let access: String?
    let address: String?
    let phoneNumber: String?
    let url: URL?
}
