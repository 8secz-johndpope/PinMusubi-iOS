//
//  YOLPGeometry.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPGeometry
struct YOLPGeometry: Decodable {
    let type: String
    let coordinates: String

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case coordinates = "Coordinates"
    }
}
