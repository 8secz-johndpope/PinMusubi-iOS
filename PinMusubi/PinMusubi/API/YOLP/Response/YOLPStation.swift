//
//  YOLPStation.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - YOLPStation
struct YOLPStation: Decodable {
    let id, subID: String
    let name: String
    let railway, exit, exitID: String?
    let distance, time: String?
    let geometry: Geometry?

    enum CodingKeys: String, CodingKey {
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
