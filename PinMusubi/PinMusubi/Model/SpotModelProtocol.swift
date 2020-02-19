//
//  SpotModelProtocol.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

internal protocol SpotModelProtocol {
    init()

    func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void)
}

internal enum ResponseStatus {
    case success
    case error
}
