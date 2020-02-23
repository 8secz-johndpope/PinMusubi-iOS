//
//  EkispertPrefecture.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertPrefecture
struct EkispertPrefecture: Decodable {
    let code, name: String

    enum CodingKeys: String, CodingKey {
        case code
        case name = "Name"
    }
}
