//
//  HotpepperRequestParameter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/22.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum HotpepperRequestParameter {
    enum Range: String, CaseIterable {
        case range300 = "1"
        case range500 = "2"
        case range1000 = "3"
        case range2000 = "4"
        case range3000 = "5"
    }

    enum Order: String, CaseIterable {
        case shopName = "1"
        case genre = "2"
        case area = "3"
        case recommend = "4"
    }

    enum Count: String, CaseIterable {
        case count10 = "10"
        case count50 = "50"
        case count100 = "100"
    }
}
