//
//  RakutenTravelHotelBasicInfo.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - RakutenTravelHotelBasicInfo
struct RakutenTravelHotelBasicInfo: Decodable, SpotInfomationProtocol {
    let hotelNo: Int
    let hotelName: String
    let hotelInformationURL, planListURL, dpPlanListURL, reviewURL: String?
    let hotelKanaName, hotelSpecial: String?
    let hotelMinCharge: Int?
    let latitude, longitude: Double
    let postalCode, address1, address2, telephoneNo: String
    let faxNo, access, parkingInformation, nearestStation: String?
    let hotelImageURL, hotelThumbnailURL: String
    let roomImageURL, roomThumbnailURL: String?
    let hotelMapImageURL: String?
    let reviewCount: Int?
    let reviewAverage: Double?
    let userReview: String?

    enum CodingKeys: String, CodingKey {
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
