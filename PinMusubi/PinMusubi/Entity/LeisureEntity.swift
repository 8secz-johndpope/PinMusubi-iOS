//
//  LeisureEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct LeisureEntity: SpotEntityProtocol {
    var name: String
    var category: String
    let imageURLString: String?
    let generalImage: String?
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var distance: Double
    let address: String?
    let nearStation: String?
    let phoneNumber: String?
    let description: String?
    let url: URL?
}
