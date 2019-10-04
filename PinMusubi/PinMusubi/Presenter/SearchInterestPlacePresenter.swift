//
//  SearchInterestPlacePresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public protocol SearchInterestPlacePresenterProtocol: AnyObject {
    init(vc: SearchInterestPlaceViewController, modelType model: SearchInterestPlaceModelProtocol.Type)

    func setSearchHistrory(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) -> Bool
}

public class SearchInterestPlacePresenter: SearchInterestPlacePresenterProtocol {
    private weak var vc: SearchInterestPlaceViewController?
    private let model: SearchInterestPlaceModelProtocol?

    public required init(vc: SearchInterestPlaceViewController, modelType model: SearchInterestPlaceModelProtocol.Type) {
        self.vc = vc
        self.model = model.init()
    }

    public func setSearchHistrory(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) -> Bool {
        guard let model = model else { return false }
        return  model.setSearchHistory(settingPoints: settingPoints, interestPoint: interestPoint)
    }
}
