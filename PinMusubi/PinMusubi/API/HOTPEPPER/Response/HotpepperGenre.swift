//
//  HotpepperGenre.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperGenre
struct HotpepperGenre: Decodable {
    public var code: String
    public var name: String
    public var genreCatch: String

    enum CodingKeys: String, CodingKey {
        case code
        case name
        case genreCatch = "catch"
    }
}
