//
//  HotpepperShop.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperShop
struct HotpepperShop: Decodable, SpotInfomationProtocol {
    let id: String
    let name: String
    let logoImage: String
    let nameKana: String
    let address: String
    let stationName: String
    let largeServiceArea: HotpepperArea
    let serviceArea: HotpepperArea
    let largeArea: HotpepperArea
    let middleArea: HotpepperArea
    let smallArea: HotpepperArea
    let lat: Double
    let lng: Double
    let genre: HotpepperGenre
    let subGenre: HotpepperSubGenre?
    let budget: HotpepperBudget
    let budgetMemo: String
    let shopCatch: String
    let capacity: Int
    let access: String
    let mobileAccess: String
    let urls: HotpepperUrls
    let photo: HotpepperPhoto
    let open: String
    let close: String
    let card: String
    let parking: String
    let shopDetailMemo: String
    let couponUrls: HotpepperCouponUrls

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoImage = "logo_image"
        case nameKana = "name_kana"
        case address
        case stationName = "station_name"
        case largeServiceArea = "large_service_area"
        case serviceArea = "service_area"
        case largeArea = "large_area"
        case middleArea = "middle_area"
        case smallArea = "small_area"
        case lat
        case lng
        case genre
        case subGenre = "sub_genre"
        case budget
        case budgetMemo = "budget_memo"
        case shopCatch = "catch"
        case capacity
        case access
        case mobileAccess = "mobile_access"
        case urls
        case photo
        case open
        case close
        case card
        case parking
        case shopDetailMemo = "shop_detail_memo"
        case couponUrls = "coupon_urls"
    }
}
