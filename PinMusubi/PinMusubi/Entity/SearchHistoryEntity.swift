//
//  SearchHistoryEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

@objcMembers
public class SearchHistoryEntity: Object {
    public dynamic var id: String = UUID().uuidString
    public dynamic var halfwayPointLatitude = CLLocationDegrees()
    public dynamic var halfwayPointLongitude = CLLocationDegrees()
    public dynamic var dateTime = Date()
    public var searchPointEntityList = List<SearchHistoryEntity>()

    override public static func primaryKey() -> String? {
        return "id"
    }
}
