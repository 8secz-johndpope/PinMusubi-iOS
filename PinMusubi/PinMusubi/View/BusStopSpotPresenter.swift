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

    func fetchBusStopList(interestPoint: CLLocationCoordinate2D)
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

    /// 駅情報を取得
    /// - Parameter interestPoint: 興味のある地点
    /// - Parameter completion: 完了ハンドラ
    public func fetchBusStopList(interestPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.fetchBusStopList(pinPoint: interestPoint, completion: { busStops, status in
            if status == .success {
                view.setSpotList(spotList: busStops)
            } else {
                view.setSpotList(spotList: [SpotEntityProtocol]())
            }
        }
        )
    }
}
