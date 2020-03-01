//
//  MKLocalSearchRequestParameter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum MKLocalSearchRequestParameter {
    enum Category {
        enum Restaurant: String, MKLocalSearchCategory {
            case izakaya
            case japaneseFood
            case westernFood
            case italian
            case french
            case chinese
            case yakiniku
            case koreanCuisine
            case ethnic
            case bar
            case ramen
            case okonomiyaki
            case cafe
            case fastFood

            func inName() -> String {
                switch self {
                case .izakaya:
                    return "居酒屋"
                case .japaneseFood:
                    return "和食"
                case .westernFood:
                    return "洋食"
                case .italian:
                    return "イタリアン"
                case .french:
                    return "フレンチ"
                case .chinese:
                    return "中華"
                case .yakiniku:
                    return "焼肉"
                case .koreanCuisine:
                    return "韓国料理"
                case .ethnic:
                    return "エスニック料理"
                case .bar:
                    return "バー"
                case .ramen:
                    return "ラーメン"
                case .okonomiyaki:
                    return "お好み焼き"
                case .cafe:
                    return "カフェ"
                case .fastFood:
                    return "ファーストフード"
                }
            }
        }

        enum Hotel: String, MKLocalSearchCategory {
            case hotel
            case resortHotel
            case ryokan

            func inName() -> String {
                switch self {
                case .hotel:
                    return "ホテル"
                case .resortHotel:
                    return "リゾートホテル"
                case .ryokan:
                    return "旅館"
                }
            }
        }

        enum Leisure: String, MKLocalSearchCategory {
            case sports
            case gameCenter
            case amusementPark
            case museum
            case aquarium
            case park
            case zoo

            func inName() -> String {
                switch self {
                case .sports:
                    return "スポーツ"
                case .gameCenter:
                    return "ゲームセンター"
                case .amusementPark:
                    return "遊園地"
                case .museum:
                    return "博物館　美術館"
                case .aquarium:
                    return "水族館"
                case .park:
                    return "公園"
                case .zoo:
                    return "動物園"
                }
            }
        }

        enum Transportation: String, MKLocalSearchCategory {
            case station
            case busStop

            func inName() -> String {
                switch self {
                case .station:
                    return "駅"
                case .busStop:
                    return "バス停"
                }
            }
        }
    }
}
