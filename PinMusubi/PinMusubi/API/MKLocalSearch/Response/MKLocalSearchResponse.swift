//
//  MKLocalSearchResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

struct MKLocalSearchResponse<Category: MKLocalSearchCategory> {
    let name: String
    let category: Category
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String?
    let url: URL?
    let phoneNumber: String?
}
