//
//  YOLPAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum YOLPAPI {
    struct LocalSearch: YOLPRequest {
        let query: String?
        let id: String?
        let sort: String?
        let results: String?
        let latitude: String?
        let longitude: String?
        let dist: String?
        let gc: String?

        typealias Response = YOLPResponse<YOLPFeature>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/search/local/V1/localSearch"
        }

        var appid: String {
            return KeyManager().getValue(key: "Yolp API Key") as? String ?? ""
        }

        var output: String {
            return "json"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "appid", value: appid),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "id", value: id),
                URLQueryItem(name: "sort", value: sort),
                URLQueryItem(name: "results", value: results),
                URLQueryItem(name: "output", value: output),
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "dist", value: dist),
                URLQueryItem(name: "gc", value: gc)
            ]
        }
    }
}
