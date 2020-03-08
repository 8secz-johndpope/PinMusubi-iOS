//
//  YOLPCountry.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPCountry
struct YOLPCountry: Decodable {
    let code, name: String

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}
