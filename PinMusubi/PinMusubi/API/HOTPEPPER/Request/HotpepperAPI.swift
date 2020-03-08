//
//  HotpepperAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/22.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum HotpepperAPI {
    struct GourmetSearch: HotpepperRequest {
        let keyword: String?
        let id: String?
        let latitude: String?
        let longitude: String?
        let range: String?
        let order: String?
        let count: String?

        typealias Response = HotpepperResponse<HotpepperShop>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/hotpepper/gourmet/v1"
        }

        var apiKey: String {
            return KeyManager().getValue(key: "Recruit API Key") as? String ?? ""
        }

        var format: String {
            return "json"
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "keyword", value: keyword),
                URLQueryItem(name: "id", value: id),
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lng", value: longitude),
                URLQueryItem(name: "range", value: range),
                URLQueryItem(name: "order", value: order),
                URLQueryItem(name: "count", value: count),
                URLQueryItem(name: "format", value: format)
            ]
        }
    }
}
