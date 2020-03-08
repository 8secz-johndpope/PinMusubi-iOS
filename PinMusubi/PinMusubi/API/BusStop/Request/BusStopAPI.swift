//
//  BusStopAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum BusStopAPI {
    struct GetBusStop: BusStopRequest {
        let latitude: String?
        let longitude: String?

        typealias Response = [BusStopResponse]

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/getBusStop"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lng", value: longitude)
            ]
        }
    }
}
