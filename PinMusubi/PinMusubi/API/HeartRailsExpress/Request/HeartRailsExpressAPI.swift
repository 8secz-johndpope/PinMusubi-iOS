//
//  HeartRailsExpressAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum HeartRailsExpressAPI {
    struct GetStations: HeartRailsExpressRequest {
        let latitude: String?
        let longitude: String?

        typealias Response = HeartRailsExpressResponse<HeartRailsExpressStation>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/api/json"
        }

        var apiMethod: String {
            return "getStations"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "method", value: apiMethod),
                URLQueryItem(name: "x", value: longitude),
                URLQueryItem(name: "y", value: latitude)
            ]
        }
    }
}
