//
//  HeartRailsExpressResponseField.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HeartRailsExpressResponseField
struct HeartRailsExpressResponseField<Item: Decodable>: Decodable {
    let station: [Item]?
    let error: String?
}
