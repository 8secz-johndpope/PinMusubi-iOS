//
//  SearchCriteriaModalViewPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

public protocol SearchCriteriaViewPresenterProtocol: AnyObject {
    init(view: SearchCriteriaView, modelType model: SearchCriteriaModelProtocol.Type)

    func validateAddress(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void)
    func convertingToCoordinate(name: String, address: String, row: Int)
    func setPointsOnMapView(settingPoints: [SettingPointEntity])
}

public class SearchCriteriaViewPresenter: SearchCriteriaViewPresenterProtocol {
    private weak var view: SearchCriteriaView?
    private let model: SearchCriteriaModelProtocol?

    public required init(view: SearchCriteriaView, modelType model: SearchCriteriaModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    public func validateAddress(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void) {
        model?.geocode(address: address, complete: { settingPoint, status in
            complete(settingPoint, status)
        }
        )
    }

    public func convertingToCoordinate(name: String, address: String, row: Int) {
        guard let model = model else {
            return }
        model.setPointName(name: name, row: row)
        model.geocoding(address: address, row: row, complete: {
        }
        )
    }

    public func setPointsOnMapView(settingPoints: [SettingPointEntity]) {
        guard let model = model else { return }
        guard let view = view else { return }
        guard let delegate = view.delegate else { return }
        delegate.setPin(settingPoints: settingPoints, halfwayPoint: model.calculateHalfPoint(settingPoints: settingPoints))
    }
}
