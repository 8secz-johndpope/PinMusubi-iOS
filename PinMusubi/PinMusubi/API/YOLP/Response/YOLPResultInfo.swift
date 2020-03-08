//
//  YOLPResultInfo.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPResultInfo
struct YOLPResultInfo: Decodable {
    let count, total, start, status: Int
    let description, copyright: String
    let latency: Double

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case total = "Total"
        case start = "Start"
        case status = "Status"
        case description = "Description"
        case copyright = "Copyright"
        case latency = "Latency"
    }
}
