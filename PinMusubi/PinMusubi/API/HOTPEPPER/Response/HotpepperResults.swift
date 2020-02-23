//
//  HotpepperResultls.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperResults
struct HotpepperResults<Item: Decodable>: Decodable {
    let apiVersion: String
    let resultsAvailable: Int?
    let resultsReturned: String?
    let resultsStart: Int?
    let shop: [Item]?
    let error: HotpepperError?

    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
        case shop
        case error
    }
}
