//
//  SpotListPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

internal protocol SpotListPresenterProtocol {
    init(view: SpotListViewController)

    func presentAllSpotList(pinPoint: CLLocationCoordinate2D, spotTypeList: [SpotType])
}

internal class SpotListPresenter: SpotListPresenterProtocol {
    private weak var view: SpotListViewController?

    internal required init(view: SpotListViewController) {
        self.view = view
    }

    internal func presentAllSpotList(pinPoint: CLLocationCoordinate2D, spotTypeList: [SpotType]) {
        guard let view = view else { return }
        var spotList = [[SpotEntityProtocol]]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "spotListQueue", attributes: .concurrent)

        spotTypeList.forEach { spotType in
            spotList.append([SpotEntityProtocol]())
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                let model = self.initModel(spotType: spotType)
                model.fetchSpotList(pinPoint: pinPoint) {
                    guard let index = spotTypeList.firstIndex(of: $1) else { return }
                    spotList[index] = $0
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            view.setAllSpotList(allSpotList: spotList)
        }
    }

    internal func initModel(spotType: SpotType) -> SpotModelProtocol {
        switch spotType {
        case .restaurant:
            return RestaurantSpotsModel()

        case .hotel:
            return HotelModel()

        case .leisure:
            return LeisureModel()

        case .transportation:
            return TransportationModel()
        }
    }
}
