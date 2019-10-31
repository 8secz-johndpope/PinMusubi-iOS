//
//  BusStopSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/30.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// バス停の一覧を表示するプレゼンターのプロトコル
public protocol BusStopSpotPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: SpotListCollectionViewCell, modelType model: BusStopModelProtcol.Type)

    func fetchBusStopList(interestPoint: CLLocationCoordinate2D, stations: [SpotEntityProtocol])
}

/// バス停の一覧を表示するプレゼンター
public class BusStopSpotPresenter: BusStopSpotPresenterProrocol {
    private weak var view: SpotListCollectionViewCell?
    private let model: BusStopModelProtcol?

    /// コンストラクタ
    public required init(view: SpotListCollectionViewCell, modelType model: BusStopModelProtcol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// バス停情報を取得
    /// - Parameter interestPoint: 興味のある地点
    /// - Parameter completion: 完了ハンドラ
    public func fetchBusStopList(interestPoint: CLLocationCoordinate2D, stations: [SpotEntityProtocol]) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.fetchBusStopList(pinPoint: interestPoint, completion: { busStops, status in
            if status == .success {
                var transportations = [SpotEntityProtocol]()
                for station in stations {
                    transportations.append(station)
                }
                for busStop in busStops {
                    transportations.append(busStop)
                }
                view.setSpotList(spotList: self.sortSpot(transportations: transportations))
            } else {
                view.setSpotList(spotList: stations)
            }
        }
        )
    }

    private func sortSpot(transportations: [SpotEntityProtocol]) -> [SpotEntityProtocol] {
        var sortedTransportations = transportations
        sortedTransportations.sort { before, after in
            var distanceBefore: Double = 0.0
            var distanceAfter: Double = 0.0
            if let before = before as? Station {
                guard let distance = Double(before.distance.dropLast()) else { return false }
                distanceBefore = Double(distance)
                if let after = after as? Station {
                    guard let distance = Double(after.distance.dropLast()) else { return false }
                    distanceAfter = Double(distance)
                } else if let after = after as? BusStopEntity {
                    distanceAfter = after.distance
                }
            } else if let before = before as? BusStopEntity {
                distanceBefore = before.distance
                if let after = after as? Station {
                    guard let distance = Double(after.distance.dropLast()) else { return false }
                    distanceAfter = Double(distance)
                } else if let after = after as? BusStopEntity {
                    distanceAfter = after.distance
                }
            }
            return distanceBefore < distanceAfter
        }
        return sortedTransportations
    }
}
