//
//  LeisureEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

// MARK: - LeisureEntity
public struct LeisureEntity: Codable {
    public let resultInfo: ResultInfo
    public let feature: [Feature]

    private enum CodingKeys: String, CodingKey {
        case resultInfo = "ResultInfo"
        case feature = "Feature"
    }
}

// MARK: - Feature
public struct Feature: Codable, SpotEntityProtocol {
    public let id, gid, name: String
    public let geometry: Geometry
    public let category: [String]
    public let featureDescription: String
    public let style: [String]
    public let property: Property

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case gid = "Gid"
        case name = "Name"
        case geometry = "Geometry"
        case category = "Category"
        case featureDescription = "Description"
        case style = "Style"
        case property = "Property"
    }
}

// MARK: - Geometry
public struct Geometry: Codable {
    public let type: String
    public let coordinates: String

    private enum CodingKeys: String, CodingKey {
        case type = "Type"
        case coordinates = "Coordinates"
    }
}
// MARK: - Property
public struct Property: Codable {
    public let uid: String
    public let cassetteID: String
    public let yomi: String?
    public let country: Country
    public let address, governmentCode, addressMatchingLevel, tel1: String?
    public let genre: [YGenre]
    public let station: [YStation]
    public let smartPhoneCouponFlag: String
    public let keepCount, rating, access1, catchCopy: String?
    public let leadImage: String?
    public let creditcardFlag, parkingFlag, couponFlag: String?
    public let coupon: [Coupon]?
    public let price, averagePriceComment: String?

    private enum CodingKeys: String, CodingKey {
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

// MARK: - Country
public struct Country: Codable {
    public let code, name: String

    private enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}

// MARK: - YGenre
public struct YGenre: Codable {
    public let code, name: String

    private enum CodingKeys: String, CodingKey {
        case code = "Code"
        case name = "Name"
    }
}

// MARK: - Coupon
public struct Coupon: Codable {
    public let pcURL, smartPhoneURL: String

    private enum CodingKeys: String, CodingKey {
        case pcURL = "PcUrl"
        case smartPhoneURL = "SmartPhoneUrl"
    }
}

// MARK: - Station
public struct YStation: Codable {
    public let id, subID: String
    public let name: String
    public let railway: String
    public let exit, exitID, distance, time: String
    public let geometry: Geometry?

    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case subID = "SubId"
        case name = "Name"
        case railway = "Railway"
        case exit = "Exit"
        case exitID = "ExitId"
        case distance = "Distance"
        case time = "Time"
        case geometry = "Geometry"
    }
}

// MARK: - ResultInfo
public struct ResultInfo: Codable {
    public let count, total, start, status: Int
    public let resultInfoDescription, copyright: String
    public let latency: Double

    private enum CodingKeys: String, CodingKey {
        case count = "Count"
        case total = "Total"
        case start = "Start"
        case status = "Status"
        case resultInfoDescription = "Description"
        case copyright = "Copyright"
        case latency = "Latency"
    }
}
