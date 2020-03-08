//
//  RakutenTravelHotelRatingInfo.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - RakutenTravelHotelRatingInfo
struct RakutenTravelHotelRatingInfo: Decodable {
    let serviceAverage, locationAverage, roomAverage, equipmentAverage: Double?
    let bathAverage, mealAverage: Double?
}
