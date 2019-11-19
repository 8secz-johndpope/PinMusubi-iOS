//
//  LeisureSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// レジャーの一覧を表示するプレゼンターのプロトコル
public protocol LeisureSpotPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: SpotListCollectionViewCell, modelType model: LeisureModelProtocol.Type)

    func fetchHotelSpotList(interestPoint: CLLocationCoordinate2D)
}

/// レジャーの一覧を表示するプレゼンター
public class LeisureSpotPresenter: LeisureSpotPresenterProrocol {
    private weak var view: SpotListCollectionViewCell?
    private let model: LeisureModelProtocol?

    /// コンストラクタ
    public required init(view: SpotListCollectionViewCell, modelType model: LeisureModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// レジャー情報を取得
    /// - Parameter interestPoint: 興味のある地点
    public func fetchHotelSpotList(interestPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.fetchLeisureList(pinPoint: interestPoint, completion: { leisures, status in
            if status == .success {
                view.setSpotList(spotList: leisures)
            } else {
                view.setSpotList(spotList: [SpotEntityProtocol]())
            }
        }
        )
    }
}
