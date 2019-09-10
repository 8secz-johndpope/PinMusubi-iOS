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
    // 中間地点情報
    var halfwayPoint: CLLocationCoordinate2D { get }
    // 地点の名前を設定する
    func setPointName(name: String, row: Int)
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int, complete: @escaping () -> Void)
    // 中間地点を計算して設定する
    func calculateHalfPoint(settingPoints: [SettingPointEntity])
}

// 検索条件を設定するビジネスモデル
class SearchCriteriaModel: SearchCriteriaModelProtocol {
    // 設定地点情報
    private(set) var settingPoints = [SettingPointEntity](repeating: SettingPointEntity(), count: 2)
    // 中間地点情報
    private(set) var halfwayPoint = CLLocationCoordinate2D()
    
    // 地点の名前を設定する
    func setPointName(name: String, row: Int) {
        settingPoints[row].name = name
    }
    
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int, complete: @escaping () -> Void) {
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
    
    // 中間地点を計算して設定する
    func calculateHalfPoint(settingPoints: [SettingPointEntity]) {
        
    }
}
