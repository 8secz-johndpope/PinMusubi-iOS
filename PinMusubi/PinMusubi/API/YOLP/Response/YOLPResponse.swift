//
//  YOLPResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPResponse
struct YOLPResponse<Item: Decodable>: Decodable {
    let resultInfo: YOLPResultInfo
    let feature: [Item]?

    enum CodingKeys: String, CodingKey {
        case resultInfo = "ResultInfo"
        case feature = "Feature"
    }
}
