//
//  FavoriteSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public protocol FavoriteSpotPresenterProtocol: AnyObject {
    init(vc: FavoriteRegisterModalViewController, modelType model: FavoriteSpotModelProtocol.Type)

    func registerFavoriteSpot(settingPoints: [SettingPointEntity], favoriteSpot: FavoriteSpotEntity) -> Bool
}

public class FavoriteSpotPresenter: FavoriteSpotPresenterProtocol {
    private weak var vc: FavoriteRegisterModalViewController?
    private let model: FavoriteSpotModelProtocol?

    public required init(vc: FavoriteRegisterModalViewController, modelType model: FavoriteSpotModelProtocol.Type) {
        self.vc = vc
        self.model = model.init()
    }

    public func registerFavoriteSpot(settingPoints: [SettingPointEntity], favoriteSpot: FavoriteSpotEntity) -> Bool {
        guard let model = model else { return false }
        return  model.setFavoriteSpot(settingPoints: settingPoints, favoriteSpot: favoriteSpot)
    }
}
