//
//  HotelSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// ホテルの一覧を表示するプレゼンターのプロトコル
public protocol HotelSpotPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: SpotListCollectionViewCell, modelType model: HotelModelProtocol.Type)

    func fetchHotelSpotList(interestPoint: CLLocationCoordinate2D)
}

/// ホテルの一覧を表示するプレゼンター
public class HotelSpotPresenter: HotelSpotPresenterProrocol {
    private weak var view: SpotListCollectionViewCell?
    private let model: HotelModelProtocol?

    /// コンストラクタ
    public required init(view: SpotListCollectionViewCell, modelType model: HotelModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// ホテル情報を取得
    /// - Parameter interestPoint: 興味のある地点
    public func fetchHotelSpotList(interestPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.fetchHotelList(pinPoint: interestPoint, completion: { hotels, status in
            if status == .success {
                view.setSpotList(spotList: hotels)
            } else {
                view.setSpotList(spotList: [SpotEntityProtocol]())
            }
        }
        )
    }
}
