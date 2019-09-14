//
//  SearchCriteria.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation

struct SettingPointEntity {
    var id: String
    var name: String
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var searchId: String

    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.address = ""
        self.latitude = CLLocationDegrees()
        self.longitude = CLLocationDegrees()
        self.searchId = ""
    }
}
