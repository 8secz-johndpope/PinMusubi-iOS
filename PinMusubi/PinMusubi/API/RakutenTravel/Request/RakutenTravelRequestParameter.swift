//
//  RakutenTravelRequestParameter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum RakutenTravelRequestParameter {
    enum SearchRadius: String, CaseIterable {
        case range300 = "0.3"
        case range500 = "0.5"
        case range1000 = "1.0"
        case range2000 = "2.0"
        case range3000 = "3.0"
    }

    enum SqueezeCondition: String, CaseIterable {
        case kinen
        case internet
        case daiyoku
        case onsen
    }

    enum HotelThumbnailSize: String, CaseIterable {
        case small = "1"
        case middle = "2"
        case large = "3"
    }

    enum ResponseType: String, CaseIterable {
        case small
        case middle
        case large
    }
}
