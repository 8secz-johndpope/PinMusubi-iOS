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
    let ktaiCoupon: String
    let largeServiceArea: HotpepperArea
    let serviceArea: HotpepperArea
    let largeArea: HotpepperArea
    let middleArea: HotpepperArea
    let smallArea: HotpepperArea
    let lat: String
    let lng: String
    let genre: HotpepperGenre
    let subGenre: HotpepperSubGenre?
    let budget: HotpepperBudget
    let budgetMemo: String
    let shopCatch: String
    let capacity: String
    let access: String
    let mobileAccess: String
    let urls: HotpepperUrls
    let photo: HotpepperPhoto
    let open: String
    let close: String
    let partyCapacity: String
    let wifi: String
    let wedding: String
    let course: String
    let freeDrink: String
    let freeFood: String
    let privateRoom: String
    let horigotatsu: String
    let tatami: String
    let card: String
    let nonSmoking: String
    let charter: String
    let ktai: String?
    let parking: String
    let barrierFree: String
    let otherMemo: String
    let sommelier: String?
    let openAir: String?
    let show: String
    let equipment: String?
    let karaoke: String
    let band: String
    let tv: String
    let english: String
    let pet: String
    let child: String
    let lunch: String
    let midnight: String
    let shopDetailMemo: String
    let couponUrls: HotpepperCouponUrls

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoImage = "logo_image"
        case nameKana = "name_kana"
        case address
        case stationName = "station_name"
        case ktaiCoupon = "ktai_coupon"
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
        case partyCapacity = "party_capacity"
        case wifi
        case wedding
        case course
        case freeDrink = "free_drink"
        case freeFood = "free_food"
        case privateRoom = "private_room"
        case horigotatsu
        case tatami
        case card
        case nonSmoking = "non_smoking"
        case charter
        case ktai
        case parking
        case barrierFree = "barrier_free"
        case otherMemo = "other_memo"
        case sommelier
        case openAir = "open_air"
        case show
        case equipment
        case karaoke
        case band
        case tv
        case english
        case pet
        case child
        case lunch
        case midnight
        case shopDetailMemo = "shop_detail_memo"
        case couponUrls = "coupon_urls"
    }
}
