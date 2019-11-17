//
//  FavoriteSpotModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// お気に入りスポットモデルのプロトコル
public protocol FavoriteSpotModelProtocol {
    /// コンストラクタ
    init()

    /// お気に入りスポットの登録
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter favoriteSpot: お気に入りスポット情報
    func setFavoriteSpot(settingPoints: [SettingPointEntity], favoriteSpot: FavoriteSpotEntity) -> Bool

    /// Firestoreへ登録
    /// - Parameter favoriteSpot: 登録するお気に入りスポット
    func addDocument(favoriteSpot: FavoriteSpotEntity)
}

public class FavoriteSpotModel: FavoriteSpotModelProtocol {
    public required init() {}

    public func setFavoriteSpot(settingPoints: [SettingPointEntity], favoriteSpot: FavoriteSpotEntity) -> Bool {
        let settingPointsList = List<SettingPointEntity>()
        for settingPoint in settingPoints {
            let setSettingPoint = SettingPointEntity()
            setSettingPoint.name = settingPoint.name
            setSettingPoint.address = settingPoint.address
            setSettingPoint.latitude = settingPoint.latitude
            setSettingPoint.longitude = settingPoint.longitude
            settingPointsList.append(setSettingPoint)
        }
        favoriteSpot.settingPointEntityList = settingPointsList

        return FavoriteSpotAccessor().set(data: favoriteSpot)
    }

    public func addDocument(favoriteSpot: FavoriteSpotEntity) {
        FavoriteSpotAccessor().addDocument(favoriteSpot: favoriteSpot)
    }
}
