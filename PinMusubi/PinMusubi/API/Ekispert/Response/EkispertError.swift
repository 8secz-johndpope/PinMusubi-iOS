//
//  EkispertError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertError
struct EkispertError: Decodable {
    let code: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message = "Message"
    }
}
