//
//  SpotEntity.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/04.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

struct SpotEntity: SpotEntityProtocol {
    /// 名前
    var name: String

    /// カテゴリー
    var category: String

    /// 画像URL
    var imageURLString: String?

    /// 汎用画像
    var generalImageName: String?

    /// 緯度
    var latitude: CLLocationDegrees

    /// 経度
    var longitude: CLLocationDegrees

    /// 距離
    var distance: Double

    /// 住所
    var address: String?

    /// 電話番号
    var phoneNumber: String?

    /// WebページURL
    var url: URL?

    /// 詳細情報
    var spotInfomation: SpotInfomationProtocol?
}
