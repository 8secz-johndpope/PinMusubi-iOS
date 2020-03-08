//
//  YOLPAPIError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

struct YOLPAPIError: Decodable, Error {
    struct FieldError: Decodable {
        let message: String

        enum CodingKeys: String, CodingKey {
            case message = "Message"
        }
    }

    let error: FieldError

    enum CodingKeys: String, CodingKey {
        case error = "Error"
    }
}
