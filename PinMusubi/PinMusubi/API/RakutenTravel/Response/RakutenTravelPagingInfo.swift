//
//  RakutenTravelPagingInfo.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - RakutenTravelPagingInfo
struct RakutenTravelPagingInfo: Decodable {
    let recordCount: Int
    let pageCount: Int
    let page: Int
    let first: Int
    let last: Int
}
