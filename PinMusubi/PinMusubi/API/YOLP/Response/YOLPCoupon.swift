//
//  YOLPCoupon.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPCoupon
struct YOLPCoupon: Decodable {
    let pcURL, smartPhoneURL: String

    enum CodingKeys: String, CodingKey {
        case pcURL = "PcUrl"
        case smartPhoneURL = "SmartPhoneUrl"
    }
}
