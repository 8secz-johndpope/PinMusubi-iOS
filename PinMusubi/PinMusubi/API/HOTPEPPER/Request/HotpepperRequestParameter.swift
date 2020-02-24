//
//  HotpepperRequestParameter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/22.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum HotpepperRequestParameter {
    enum Range: String, CaseIterable {
        case _300 = "1"
        case _500 = "2"
        case _1000 = "3"
        case _2000 = "4"
        case _3000 = "5"
    }

    enum Order: String, CaseIterable {
        case shopName = "1"
        case genre = "2"
        case area = "3"
        case recommend = "4"
    }

    enum Count: String, CaseIterable {
        case _10 = "10"
        case _50 = "50"
        case _100 = "100"
    }
}
