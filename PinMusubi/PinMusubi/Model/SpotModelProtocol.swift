//
//  SpotModelProtocol.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

protocol SpotModelProtocol {
    init()

    func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void)
}

extension SpotModelProtocol {
    func getDitance(pinPoint: CLLocationCoordinate2D, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) -> Double {
        guard let latitude = latitude else { return -1 }
        guard let longitude = longitude else { return -1 }

        let pinLocation = CLLocation(latitude: pinPoint.latitude, longitude: pinPoint.longitude)
        let placeLocation = CLLocation(latitude: latitude, longitude: longitude)
        return placeLocation.distance(from: pinLocation)
    }
}

enum ResponseStatus {
    case success
    case error
}
