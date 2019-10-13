//
//  SettingBasePointsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

/// 検索条件を設定するビジネスモデルのプロトコル
public protocol SettingBasePointsModelProtocol {
    /// コンストラクタ
    init()

    /// 住所等から地理座標を設定
    /// - Parameter address: 住所等情報
    /// - Parameter complete: 完了ハンドラ
    func geocode(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void)

    /// 中間地点を計算して返却する
    func calculateHalfPoint(settingPoints: [SettingPointEntity]) -> CLLocationCoordinate2D
}

/// 検索条件を設定するビジネスモデル
public class SettingBasePointsModel: SettingBasePointsModelProtocol {
    /// コンストラクタ
    public required init() {}

    /// 住所等から地理座標を設定
    /// - Parameter address: 住所等情報
    /// - Parameter complete: 完了ハンドラ
    public func geocode(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void) {
        let settingPoint = SettingPointEntity()
        CLGeocoder().geocodeAddressString(address, completionHandler: {placemark, error -> Void in
            if (error) == nil {
                guard let coordinate = placemark?.first?.location?.coordinate else { return }
                settingPoint.address = address
                settingPoint.latitude = coordinate.latitude
                settingPoint.longitude = coordinate.longitude
                complete(settingPoint, .success)
            } else {
                complete(settingPoint, .error)
            }
        }
        )
    }

    /// 中間地点を計算して返却
    /// - Parameter settingPoints: 設定地点リスト
    public func calculateHalfPoint(settingPoints: [SettingPointEntity]) -> CLLocationCoordinate2D {
        var halfwayPoint = CLLocationCoordinate2D()
        for settingPoint in settingPoints {
            halfwayPoint.latitude += settingPoint.latitude
            halfwayPoint.longitude += settingPoint.longitude
        }
        halfwayPoint.latitude /= Double(settingPoints.count)
        halfwayPoint.longitude /= Double(settingPoints.count)
        return halfwayPoint
    }
}