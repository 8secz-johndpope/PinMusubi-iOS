//
//  SearchConditonsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import CoreLocation

// 通知プロトコル
protocol SearchCriteriaModelNotify {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
}

// 検索条件を設定するビジネスモデルのプロトコル
protocol SearchCriteriaModelProtocol: SearchCriteriaModelNotify {
    // 設定地点情報
    var settingPoints: [SettingPointEntity] { get }
    // 地点の名前を設定する
    func setPointName(name: String, row: Int)
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int)
}

// 検索条件を設定するビジネスモデル
class SearchCriteriaModel: SearchCriteriaModelProtocol {
    // 設定地点情報
    private(set) var settingPoints = [SettingPointEntity](repeating: SettingPointEntity(), count: 2)
    
    // 地点の名前を設定する
    func setPointName(name: String, row: Int) {
        settingPoints[row].name = name
    }
    
    // 住所等から地理座標を設定する
    func geocoding(address: String, row: Int) {
        settingPoints[row].address = address
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) == nil){
                guard let coordinate = placemarks?.first?.location?.coordinate else {
                    self.notify()
                    return
                }
                self.settingPoints[row].latitude = coordinate.latitude
                self.settingPoints[row].longitude = coordinate.longitude
            }
            self.notify()
        })
    }
}

// 通知設定の実装
extension SearchCriteriaModel: SearchCriteriaModelNotify {
    // 通知設定の名前
    var notificationName: Notification.Name {
        return Notification.Name(rawValue: "geocording")
    }
    // 通知を設定
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }
    // 通知を削除
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    // 通知を送信
    func notify() {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
