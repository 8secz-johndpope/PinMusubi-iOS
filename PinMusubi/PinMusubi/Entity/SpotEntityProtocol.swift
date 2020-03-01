//
//  SpotEntityProtocol.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

/// スポットのプロトコル
public protocol SpotEntityProtocol {
    /// スポットの名前
    var name: String { get }

    /// スポットのカテゴリー
    var category: String { get }

    /// スポットの緯度
    var latitude: CLLocationDegrees { get }

    /// スポットの経度
    var longitude: CLLocationDegrees { get }

    /// スポットまでの距離
    var distance: Double { get }
}
