//
//  HotelEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

// MARK: - HotelEntity
public class HotelEntity: Codable {
    public let pagingInfo: PagingInfo
    public let hotels: [Hotels]
}

// MARK: - HotelEntityHotel
public class Hotels: Codable, SpotEntityProtocol {
    public let hotel: [Hotel]
}

// MARK: - HotelHotel
public class Hotel: Codable {
    public let hotelBasicInfo: HotelBasicInfo?
    public let hotelRatingInfo: HotelRatingInfo?
}

// MARK: - HotelBasicInfo
public class HotelBasicInfo: Codable {
    public let hotelNo: Int
    public let hotelName: String
    public let hotelInformationURL, planListURL, dpPlanListURL, reviewURL: String?
    public let hotelKanaName, hotelSpecial: String
    public let hotelMinCharge: Int?
    public let latitude, longitude: Double
    public let postalCode, address1, address2, telephoneNo: String
    public let faxNo, access, parkingInformation, nearestStation: String?
    public let hotelImageURL, hotelThumbnailURL: String
    public let roomImageURL, roomThumbnailURL: String?
    public let hotelMapImageURL: String
    public let reviewCount: Int?
    public let reviewAverage: Double?
    public let userReview: String?

    private enum CodingKeys: String, CodingKey {
        case hotelNo, hotelName
        case hotelInformationURL = "hotelInformationUrl"
        case planListURL = "planListUrl"
        case dpPlanListURL = "dpPlanListUrl"
        case reviewURL = "reviewUrl"
        case hotelKanaName, hotelSpecial, hotelMinCharge, latitude, longitude, postalCode, address1, address2, telephoneNo, faxNo, access, parkingInformation, nearestStation
        case hotelImageURL = "hotelImageUrl"
        case hotelThumbnailURL = "hotelThumbnailUrl"
        case roomImageURL = "roomImageUrl"
        case roomThumbnailURL = "roomThumbnailUrl"
        case hotelMapImageURL = "hotelMapImageUrl"
        case reviewCount, reviewAverage, userReview
    }
}

// MARK: - HotelRatingInfo
public class HotelRatingInfo: Codable {
    public let serviceAverage, locationAverage, roomAverage, equipmentAverage: Double?
    public let bathAverage, mealAverage: Double?
}

// MARK: - PagingInfo
public class PagingInfo: Codable {
    public let recordCount, pageCount, page, first: Int
    public let last: Int
}
