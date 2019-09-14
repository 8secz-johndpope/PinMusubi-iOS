//
//  SearchConditonsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Foundation

// 検索条件を設定するビジネスモデルのプロトコル
private protocol SearchCriteriaModelProtocol {
    // 設定地点情報
    var settingPoints: [SettingPointEntity] { get }
    // 設定地点情報を管理
    func manageSettingPoints(row: Int)
    // 地点の名前を設定する
    func setPointName(name: String, row: Int)
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int, complete: @escaping () -> Void)
    // 中間地点を計算して返却する
    func calculateHalfPoint() -> CLLocationCoordinate2D
}

// 検索条件を設定するビジネスモデル
public class SearchCriteriaModel: SearchCriteriaModelProtocol {
    // 設定地点情報
    internal private(set) var settingPoints = [SettingPointEntity]()

    // 設定地点情報を管理
    public func manageSettingPoints(row: Int) {
        if settingPoints.count <= row {
            for _ in settingPoints.count...row {
                settingPoints.append(SettingPointEntity())
            }
        }
    }

    // 地点の名前を設定する
    public func setPointName(name: String, row: Int) {
        manageSettingPoints(row: row)
        settingPoints[row].name = name
    }

    // 住所等から地理座標を設定する
    public func geocoding(address: String, row: Int, complete: @escaping () -> Void) {
        manageSettingPoints(row: row)
        CLGeocoder().geocodeAddressString(address, completionHandler: {placemarks, error -> Void in
            if (error) == nil {
                guard let coordinate = placemarks?.first?.location?.coordinate else {
                    complete()
                    return
                }
                self.settingPoints[row].address = address
                self.settingPoints[row].latitude = coordinate.latitude
                self.settingPoints[row].longitude = coordinate.longitude
            }
            complete()
        }
        )
    }

    // 中間地点を計算して返却する
    public func calculateHalfPoint() -> CLLocationCoordinate2D {
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
