//
//  EkispertResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - EkispertResponse
struct EkispertResponse<Item: Decodable>: Decodable {
    let resultSet: EkispertResultSet<Item>

    enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }
}
