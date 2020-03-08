//
//  EkispertResultSet.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertResultSet
struct EkispertResultSet<Item: Decodable>: Decodable {
    let apiVersion: String
    let engineVersion: String
    let resourceURI: String?
    let max: String?
    let offset: String?
    let point: Item?
    let error: EkispertError?

    enum CodingKeys: String, CodingKey {
        case apiVersion
        case engineVersion
        case resourceURI = "ResourceURI"
        case max
        case offset
        case point = "Point"
        case error = "Error"
    }
}
