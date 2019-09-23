//
//  SearchCriteriaViewPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

public protocol SearchCriteriaViewPresenterProtocol: AnyObject {
    init(view: ModalContentView, modelType model: SearchCriteriaModelProtocol.Type)

    func convertingToCoordinate(name: String, address: String, row: Int)
    func setPointsOnMap()
}

public class SearchCriteriaViewPresenter: SearchCriteriaViewPresenterProtocol {
    private weak var view: ModalContentView?
    private let model: SearchCriteriaModelProtocol?

    public required init(view: ModalContentView, modelType model: SearchCriteriaModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    public func convertingToCoordinate(name: String, address: String, row: Int) {
        guard let model = model else {
            return }
        guard let view = view else {
            return }
        model.setPointName(name: name, row: row)
        model.geocoding(address: address, row: row, complete: {
            view.setMessage(canDone: model.settingPoints[row].address != "", row: row)
        }
        )
    }

    public func setPointsOnMap() {
        guard let model = model else { return }
        guard let view = view else { return }
        guard let delegate = view.delegate else { return }
        delegate.setPin(settingPoints: model.settingPoints, halfwayPoint: model.calculateHalfPoint())
    }
}
