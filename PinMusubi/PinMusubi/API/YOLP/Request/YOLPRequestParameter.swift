//
//  YOLPRequestParameter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum YOLPRequestParameter {
    enum Sort: String, CaseIterable {
        case rating
        case score
        case hybrid
        case review
        case kana
        case price
        case dist
        case geo
        case match
    }

    enum Results: String, CaseIterable {
        case result10 = "10"
        case result50 = "50"
        case result100 = "100"
    }

    enum Dist: String, CaseIterable {
        case dist300 = "0.3"
        case dist500 = "0.5"
        case dist1000 = "1.0"
        case dist2000 = "2.0"
        case dist3000 = "3.0"
    }

    enum GC {
        enum Leisure: String, CaseIterable {
            case sports = "0301"    // スポーツ
            case gameCenter = "0302"    // 麻雀、ゲームセンター
            case leisure = "0303"   // レジャー、趣味
            case entertainment = "0305"   // エンタメ、映画館、美術館
            case travel = "0307"    // 旅行サービス
        }
    }
}
