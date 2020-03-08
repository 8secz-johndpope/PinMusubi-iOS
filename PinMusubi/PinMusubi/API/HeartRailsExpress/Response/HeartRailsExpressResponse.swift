//
//  HeartRailsExpressResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HeartRailsExpressResponses
struct HeartRailsExpressResponse<Item: Decodable>: Decodable {
    let response: HeartRailsExpressResponseField<Item>
}
