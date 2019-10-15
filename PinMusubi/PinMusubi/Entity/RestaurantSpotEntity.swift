//
//  RestaurantSpotEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public struct RestaurantSpotEntity: Codable {
    public var resultsAvailable: Int
    public var shops: [Shop]

    private enum CodingKeys: String, CodingKey {
        case resultsAvailable = "results_available"
        case shops
    }
}

public struct Shop: Codable {
    public var id: String
    public var name: String
    public var logoImage: String
    public var nameKana: String
    public var address: String
    public var stationName: String
    public var lat: CLLocationDegrees
    public var lng: CLLocationDegrees
    public var genre: Genre
    public var subGenre: SubGenre
    public var budget: Budget
    public var budgetMemo: String
    public var shopCatch: String
    public var capacity: Int
    public var access: String
    public var mobileAccess: String
    public var urls: Url
    public var photo: Photo
    public var open: String
    public var close: String
    public var partyCapacity: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoImage = "logo_image"
        case nameKana = "name_kana"
        case address
        case stationName = "station_name"
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
    }
}

public struct Genre: Codable {
    public var code: String
    public var name: String
    public var genreCatch: String

    private enum CodingKeys: String, CodingKey {
        case code
        case name
        case genreCatch = "catch"
    }
}

public struct SubGenre: Codable {
    public var code: String
    public var name: String
}

public struct Budget: Codable {
    public var code: String
    public var name: String
    public var average: String
}

public struct Url: Codable {
    public var pcUrl: String

    private enum CodingKeys: String, CodingKey {
        case pcUrl = "pc"
    }
}

public struct Photo: Codable {
    public var pcPhoto: PcSize
    public var mobilePhoto: Mobile

    private enum CodingKeys: String, CodingKey {
        case pcPhoto = "pc"
        case mobilePhoto = "mobile"
    }
}

public struct PcSize: Codable {
    public var large: String
    public var middle: String
    public var small: String

    private enum CodingKeys: String, CodingKey {
        case large = "l"
        case middle = "m"
        case small = "s"
    }
}

public struct Mobile: Codable {
    public var large: String
    public var small: String

    private enum CodingKeys: String, CodingKey {
        case large = "l"
        case small = "s"
    }
}
