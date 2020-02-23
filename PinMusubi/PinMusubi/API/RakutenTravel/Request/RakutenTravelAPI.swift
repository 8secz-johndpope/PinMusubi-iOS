//
//  RakutenTravelAPI.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

enum RakutenTravelAPI {
    struct SimpleHotelSearch: RakutenTravelRequest {
        let latitude: String?
        let longitude: String?
        let searchRadius: String?
        let squeezeCondition: String?

        typealias Response = RakutenTravelResponse<RakutenTravelHotel>

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/services/api/Travel/SimpleHotelSearch/20170426"
        }

        var applicationId: String {
            return KeyManager().getValue(key: "Rakuten API Key") as? String ?? ""
        }

        var affiliateId: String {
            return KeyManager().getValue(key: "Rakuten Affiliate Id") as? String ?? ""
        }

        var format: String {
            return "json"
        }

        var formatVersion: String {
            //return "1"   // 前Ver
            return "2"  // 最新Ver（2020/02/23現在）
        }

        var datumType: String {
            return "1"  // 世界測地系、単位は度
            //return "2"   // 日本測地系、単位は秒
        }

        var allReturnFlag: String {
            return "1"  // 全件返却
        }

        var queryItems: [URLQueryItem] {
            return [
                URLQueryItem(name: "applicationId", value: applicationId),
                URLQueryItem(name: "affiliateId", value: affiliateId),
                URLQueryItem(name: "format", value: format),
                URLQueryItem(name: "formatVersion", value: formatVersion),
                URLQueryItem(name: "latitude", value: latitude),
                URLQueryItem(name: "longitude", value: longitude),
                URLQueryItem(name: "searchRadius", value: searchRadius),
                URLQueryItem(name: "squeezeCondition", value: squeezeCondition),
                URLQueryItem(name: "datumType", value: datumType),
                URLQueryItem(name: "allReturnFlag", value: allReturnFlag)
            ]
        }
    }
}
