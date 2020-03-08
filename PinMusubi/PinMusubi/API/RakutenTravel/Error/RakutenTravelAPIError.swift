//
//  RakutenTravelAPIError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

struct RakutenTravelAPIError: Decodable, Error {
    let error: String
    let errorDescription: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
