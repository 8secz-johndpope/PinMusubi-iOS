//
//  SpotListPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

protocol SpotListPresenterProtocol {
    init(view: SpotListViewController)

    func presentAllSpotList(pinPoint: CLLocationCoordinate2D, spotTypeList: [SpotType], region: Double)
}

class SpotListPresenter: SpotListPresenterProtocol {
    private weak var view: SpotListViewController?

    required init(view: SpotListViewController) {
        self.view = view
    }

    func presentAllSpotList(pinPoint: CLLocationCoordinate2D, spotTypeList: [SpotType], region: Double) {
        guard let view = view else { return }
        var spotList = [[SpotEntityProtocol]]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "spotListQueue", attributes: .concurrent)

        spotTypeList.forEach { spotType in
            spotList.append([SpotEntityProtocol]())
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                let model = self.initModel(pinPoint: pinPoint, spotType: spotType)
                model.fetchSpotList(region: region) {
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

    func initModel(pinPoint: CLLocationCoordinate2D, spotType: SpotType) -> SpotModelProtocol {
        switch spotType {
        case .restaurant:
            return RestaurantModel(pinPoint: pinPoint)

        case .hotel:
            return HotelModel(pinPoint: pinPoint)

        case .leisure:
            return LeisureModel(pinPoint: pinPoint)

        case .transportation:
            return TransportationModel(pinPoint: pinPoint)
        }
    }
}
