//
//  MKPlacemark+Extension.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import MapKit

extension MKPlacemark {
    var address: String {
        let components = [self.administrativeArea, self.locality, self.thoroughfare, self.subThoroughfare]
        return components.reversed().compactMap { $0 }.joined(separator: ",")
    }
}
