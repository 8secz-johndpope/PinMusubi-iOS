//
//  LeisureEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

struct LeisureEntity: SpotEntityProtocol {
    let name: String
    let category: String?
    let imageURLString: String?
    let generalImage: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let distance: Double
    let address: String?
    let nearStation: String?
    let phoneNumber: String?
    let description: String?
    let url: URL?
}
