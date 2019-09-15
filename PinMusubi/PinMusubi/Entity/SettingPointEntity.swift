//
//  SearchCriteria.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation
import RealmSwift

@objcMembers
public class SettingPointEntity: Object {
    public dynamic var id: String = UUID().uuidString
    public dynamic var name: String = ""
    public dynamic var address: String = ""
    public dynamic var latitude = CLLocationDegrees()
    public dynamic var longitude = CLLocationDegrees()
    public dynamic var searchId: String = ""

    override public static func primaryKey() -> String? {
        return "id"
    }
}
