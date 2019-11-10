//
//  MyDataPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/06.
//  Copyright © 2019 naipaka. All rights reserved.
//

public protocol MyDataPresenterProtocol: AnyObject {
    init(view: MyPageCollectionViewCell, modelType model: MyDataModelProtocol.Type)

    func getFavoriteDataList(orderType: MyDataOrderType) -> [FavoriteSpotEntity]

    func getHistoryDataList(orderType: MyDataOrderType) -> [SearchHistoryEntity]
}

public class MyDataPresenter: MyDataPresenterProtocol {
    private weak var view: MyPageCollectionViewCell?
    private let model: MyDataModelProtocol?

    public required init(view: MyPageCollectionViewCell, modelType model: MyDataModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    public func getFavoriteDataList(orderType: MyDataOrderType) -> [FavoriteSpotEntity] {
        guard let model = model else { return [FavoriteSpotEntity]() }
        return model.fetchFavoriteDataList(orderType: orderType)
    }

    public func getHistoryDataList(orderType: MyDataOrderType) -> [SearchHistoryEntity] {
        guard let model = model else { return [SearchHistoryEntity]() }
        return model.fetchHistoryDataList(orderType: orderType)
    }
}
