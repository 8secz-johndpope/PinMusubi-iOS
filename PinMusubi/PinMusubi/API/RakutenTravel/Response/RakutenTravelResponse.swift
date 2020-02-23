//
//  RakutenTravelResponse.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - RakutenTravelResponse
struct RakutenTravelResponse<Item: Decodable>: Decodable {
    let pagingInfo: PagingInfo
    let hotels: [[Item]]
}
