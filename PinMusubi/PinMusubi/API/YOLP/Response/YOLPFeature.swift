//
//  YOLPFeature.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPFeature
struct YOLPFeature: Decodable {
    let id, gid, name: String
    let geometry: YOLPGeometry
    let category: [String]
    let featureDescription: String
    let style: [String]
    let property: YOLPProperty

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case gid = "Gid"
        case name = "Name"
        case geometry = "Geometry"
        case category = "Category"
        case featureDescription = "Description"
        case style = "Style"
        case property = "Property"
    }
}
