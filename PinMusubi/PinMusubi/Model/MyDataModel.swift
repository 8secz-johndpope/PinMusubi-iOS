//
//  MyDataModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/06.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// 並び順
public enum MyDataOrderType {
    /// 登録日時で昇順
    case ascendingByCreateDate
    /// 登録日時で降順
    case descendingByCreateDate
}

/// 個人データモデルのプロトコル
public protocol MyDataModelProtocol {
    /// コンストラクタ
    init()

    /// idをもとにお気に入りデータを取得
    /// - Parameter id: id
    func fetchFavoriteData(id: String) -> FavoriteSpotEntity

    /// お気に入りデータ取得
    /// - Parameter orderType: 並び順
    func fetchFavoriteDataList(orderType: MyDataOrderType) -> [FavoriteSpotEntity]

    /// Firestoreから削除
    /// - Parameter id: document_id
    func deleteDocument(id: String)

    /// idをもとにお気に入りデータを削除
    /// - Parameter id: id
    func deleteFavoriteData(id: String) -> Bool

    /// 検索履歴データ取得
    /// - Parameter orderType: 並び順
    func fetchHistoryDataList(orderType: MyDataOrderType) -> [SearchHistoryEntity]

    /// idをもとに検索履歴データを削除
    /// - Parameter id: id
    func deleteHistoryData(id: String) -> Bool
}

public class MyDataModel: MyDataModelProtocol {
    public required init() {}

    public func fetchFavoriteData(id: String) -> FavoriteSpotEntity {
        guard let favoriteData = FavoriteSpotAccessor().getByID(id: id) else { return FavoriteSpotEntity() }
        return favoriteData
    }

    public func fetchFavoriteDataList(orderType: MyDataOrderType) -> [FavoriteSpotEntity] {
        guard let results = FavoriteSpotAccessor().getAll() else { return  [FavoriteSpotEntity]() }
        var favoriteDataList = [FavoriteSpotEntity]()
        for result in results {
            let favoriteData = FavoriteSpotEntity()
            favoriteData.id = result.id
            favoriteData.rating = result.rating
            favoriteData.title = result.title
            favoriteData.memo = result.memo
            favoriteData.latitude = result.latitude
            favoriteData.longitude = result.longitude
            favoriteData.dateTime = result.dateTime
            favoriteData.settingPointEntityList = result.settingPointEntityList
            favoriteDataList.append(favoriteData)
        }

        if orderType == .descendingByCreateDate {
            favoriteDataList = favoriteDataList.sorted(by: { $0.dateTime > $1.dateTime })
        } else if orderType == .ascendingByCreateDate {
            favoriteDataList = favoriteDataList.sorted(by: { $0.dateTime < $1.dateTime })
        }

        return favoriteDataList
    }

    public func deleteFavoriteData(id: String) -> Bool {
        return FavoriteSpotAccessor().deleteById(id: id)
    }

    public func deleteDocument(id: String) {
        FavoriteSpotAccessor().deleteDocument(id: id)
    }

    public func fetchHistoryDataList(orderType: MyDataOrderType) -> [SearchHistoryEntity] {
        guard let results = SearchHistoryAccessor().getAll() else { return [SearchHistoryEntity]() }
        var historyDataList = [SearchHistoryEntity]()
        for result in results {
            let historyData = SearchHistoryEntity()
            historyData.id = result.id
            historyData.halfwayPointLatitude = result.halfwayPointLatitude
            historyData.halfwayPointLongitude = result.halfwayPointLongitude
            historyData.address = result.address
            historyData.dateTime = result.dateTime
            historyData.settingPointEntityList = result.settingPointEntityList
            historyDataList.append(historyData)
        }

        if orderType == .descendingByCreateDate {
            historyDataList = historyDataList.sorted(by: { $0.dateTime > $1.dateTime })
        } else if orderType == .ascendingByCreateDate {
            historyDataList = historyDataList.sorted(by: { $0.dateTime < $1.dateTime })
        }

        return historyDataList
    }

    public func deleteHistoryData(id: String) -> Bool {
        return SearchHistoryAccessor().deleteById(id: id)
    }
}
