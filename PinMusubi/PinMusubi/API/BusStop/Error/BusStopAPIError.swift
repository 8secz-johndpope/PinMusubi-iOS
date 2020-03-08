//
//  BusStopAPIError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

struct BusStopAPIError: Decodable, Error {
    struct FieldErrors: Decodable {
        let code: Int
        let message: String
    }

    let errors: [FieldErrors]
}
