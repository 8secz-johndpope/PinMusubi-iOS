//
//  YOLPProperty.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPProperty
struct YOLPProperty: Decodable {
    let uid: String
    let cassetteID: String
    let yomi: String?
    let country: YOLPCountry
    let address, governmentCode, addressMatchingLevel, tel1: String?
    let genre: [YOLPGenre]
    let station: [YOLPStation]
    let smartPhoneCouponFlag: String
    let keepCount, rating, access1, catchCopy: String?
    let leadImage: String?
    let creditcardFlag, parkingFlag, couponFlag: String?
    let coupon: [YOLPCoupon]?
    let price, averagePriceComment: String?

    enum CodingKeys: String, CodingKey {
        case uid = "Uid"
        case cassetteID = "CassetteId"
        case yomi = "Yomi"
        case country = "Country"
        case address = "Address"
        case governmentCode = "GovernmentCode"
        case addressMatchingLevel = "AddressMatchingLevel"
        case tel1 = "Tel1"
        case genre = "Genre"
        case station = "Station"
        case smartPhoneCouponFlag = "SmartPhoneCouponFlag"
        case keepCount = "KeepCount"
        case rating = "Rating"
        case access1 = "Access1"
        case catchCopy = "CatchCopy"
        case leadImage = "LeadImage"
        case creditcardFlag = "CreditcardFlag"
        case parkingFlag = "ParkingFlag"
        case couponFlag = "CouponFlag"
        case coupon = "Coupon"
        case price = "Price"
        case averagePriceComment = "AveragePriceComment"
    }
}
