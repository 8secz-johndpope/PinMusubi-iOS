//
//  EkispertAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum EkispertAPI {
    struct SearchCourse: EkispertRequest {
        let fromStation: String
        let toStation: String

        typealias Response = EkispertResponse<EkispertPoint>
        typealias Response2 = EkispertResponse<[EkispertPoint]>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/v1/json/search/course/light"
        }

        var key: String {
            return KeyManager().getValue(key: "Ekispert API Key") as? String ?? ""
        }

        var format: String {
            return "json"
        }

        var contentsMode: String {
            return "sp"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "from", value: fromStation),
                URLQueryItem(name: "to", value: toStation),
                URLQueryItem(name: "contentsMode", value: contentsMode)
            ]
        }
    }

    struct SearchStation: EkispertRequest {
        let name: String

        typealias Response = EkispertResponse<EkispertPoint>
        typealias Response2 = EkispertResponse<[EkispertPoint]>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/v1/json/station"
        }

        var key: String {
            return KeyManager().getValue(key: "Ekispert API Key") as? String ?? ""
        }

        var format: String {
            return "json"
        }

        var gcs: String {
            return "wgs84"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "gcs", value: gcs)
            ]
        }
    }
}
