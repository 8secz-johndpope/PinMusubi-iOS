//
//  EkispertStation.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertStation
struct EkispertStation: Decodable {
    let code, name, type, yomi: String

    enum CodingKeys: String, CodingKey {
        case code
        case name = "Name"
        case type = "Type"
        case yomi = "Yomi"
    }
}
