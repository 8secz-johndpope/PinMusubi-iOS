//
//  HotpepperResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperResponse
struct HotpepperResponse<Item: Decodable>: Decodable {
    let results: HotpepperResults<Item>
}
