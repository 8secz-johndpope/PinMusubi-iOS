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
            case japaneseFood
            case westernFood
            case italianFood
            case frenchCuisine
            case chineseCuisine
            case koreanCuisine
            case ethnicFood
            case bar
            case cafe
            case fastFood

            func getSearchName() -> String {
                switch self {
                case .japaneseFood:
                    return "Japanese food"
                case .westernFood:
                    return "Western food"
                case .italianFood:
                    return "Italian food"
                case .frenchCuisine:
                    return "French cuisine"
                case .chineseCuisine:
                    return "Chinese cuisine"
                case .koreanCuisine:
                    return "Korean cuisine"
                case .ethnicFood:
                    return "Ethnic food"
                case .bar:
                    return "Bar"
                case .cafe:
                    return "Cafe"
                case .fastFood:
                    return "Fast food"
                }
            }

            func getDisplayName() -> String {
                switch self {
                case .japaneseFood:
                    return "和食"
                case .westernFood:
                    return "洋食"
                case .italianFood:
                    return "イタリアン"
                case .frenchCuisine:
                    return "フレンチ"
                case .chineseCuisine:
                    return "中華"
                case .koreanCuisine:
                    return "韓国料理"
                case .ethnicFood:
                    return "エスニック料理"
                case .bar:
                    return "バー"
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

            func getSearchName() -> String {
                switch self {
                case .hotel:
                    return "Hotel"
                case .resortHotel:
                    return "Resort hotel"
                }
            }

            func getDisplayName() -> String {
                switch self {
                case .hotel:
                    return "ホテル"
                case .resortHotel:
                    return "リゾートホテル"
                }
            }
        }

        enum Leisure: String, MKLocalSearchCategory {
            case amusementPark
            case museum
            case aquarium
            case park
            case zoo

            func getSearchName() -> String {
                switch self {
                case .amusementPark:
                    return "Amusement park"
                case .museum:
                    return "museum"
                case .aquarium:
                    return "Aquarium"
                case .park:
                    return "Park"
                case .zoo:
                    return "Zoo"
                }
            }

            func getDisplayName() -> String {
                switch self {
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

            func getSearchName() -> String {
                switch self {
                case .station:
                    return "Station"
                case .busStop:
                    return "Bus stop"
                }
            }

            func getDisplayName() -> String {
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
