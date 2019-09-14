//
//  SearchConditonsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import CoreLocation

// 検索条件を設定するビジネスモデルのプロトコル
protocol SearchCriteriaModelProtocol {
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
class SearchCriteriaModel: SearchCriteriaModelProtocol {
    // 設定地点情報
    private(set) var settingPoints = [SettingPointEntity]()
    
    // 設定地点情報を管理
    func manageSettingPoints(row: Int) {
        if settingPoints.count <= row {
            for _ in settingPoints.count...row {
                settingPoints.append(SettingPointEntity())
            }
        }
    }
    
    // 地点の名前を設定する
    func setPointName(name: String, row: Int) {
        manageSettingPoints(row: row)
        settingPoints[row].name = name
    }
    
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int, complete: @escaping () -> Void) {
        manageSettingPoints(row: row)
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) == nil){
                guard let coordinate = placemarks?.first?.location?.coordinate else {
                    complete()
                    return
                }
                self.settingPoints[row].address = address
                self.settingPoints[row].latitude = coordinate.latitude
                self.settingPoints[row].longitude = coordinate.longitude
            }
            complete()
        })
    }
    
    // 中間地点を計算して返却する
    func calculateHalfPoint() -> CLLocationCoordinate2D {
        var halfwayPoint = CLLocationCoordinate2D()
        for settingPoint in settingPoints {
            halfwayPoint.latitude = halfwayPoint.latitude + settingPoint.latitude
            halfwayPoint.longitude = halfwayPoint.longitude + settingPoint.longitude
        }
        halfwayPoint.latitude = halfwayPoint.latitude / Double(settingPoints.count)
        halfwayPoint.longitude = halfwayPoint.longitude / Double(settingPoints.count)
        return halfwayPoint
    }
}
