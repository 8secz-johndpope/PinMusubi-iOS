//
//  SearchCriteria.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import CoreLocation

struct SettingPointEntity {
    var id: String
    var name: String
    var address: String
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    var searchId: String
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.address = ""
        self.longitude = CLLocationDegrees()
        self.latitude = CLLocationDegrees()
        self.searchId = ""
    }
}
