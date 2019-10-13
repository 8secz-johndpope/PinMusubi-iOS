//
//  SearchInterestPlaceModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import RealmSwift

/// 場所検索のModelのプロトコル
public protocol SearchInterestPlaceModelProtocol {
    /// コンストラクタ
    init()

    /// 検索履歴登録
    /// - Parameter settingPoints: 設定地点のリスト
    /// - Parameter interestPoint: 興味のある地点
    func setSearchHistory(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) -> Bool
}

public class SearchInterestPlaceModel: SearchInterestPlaceModelProtocol {
    public required init() {}

    public func setSearchHistory(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) -> Bool {
        let searchHistory = SearchHistoryEntity()
        let settingPointsList = List<SettingPointEntity>()
        for settingPoint in settingPoints {
            let setSettingPoint = SettingPointEntity()
            setSettingPoint.name = settingPoint.name
            setSettingPoint.address = settingPoint.address
            setSettingPoint.latitude = settingPoint.latitude
            setSettingPoint.longitude = settingPoint.longitude
            settingPointsList.append(setSettingPoint)
        }
        searchHistory.settingPointEntityList = settingPointsList
        searchHistory.halfwayPointLatitude = interestPoint.latitude
        searchHistory.halfwayPointLongitude = interestPoint.longitude
        return SearchHistoryAccessor().set(data: searchHistory)
    }
}