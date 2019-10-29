//
//  RestaurantSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 飲食店の一覧を表示するプレゼンターのプロトコル
public protocol RestaurantSpotPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: SpotListCollectionViewCell, modelType model: RestaurantSpotsModelProtocol.Type)

    func fetchRestaurantSpotList(interestPoint: CLLocationCoordinate2D, order: OrderType, complete: @escaping () -> Void)
}

/// 飲食店の一覧を表示するプレゼンター
public class RestaurantSpotPresenter: RestaurantSpotPresenterProrocol {
    private weak var view: SpotListCollectionViewCell?
    private let model: RestaurantSpotsModelProtocol?

    /// コンストラクタ
    public required init(view: SpotListCollectionViewCell, modelType model: RestaurantSpotsModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func fetchRestaurantSpotList(interestPoint: CLLocationCoordinate2D, order: OrderType, complete: @escaping () -> Void) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.fetchRestaurantSpotList(pinPoint: interestPoint, order: order, completion: { shops, status in
            if status == .success {
                view.setSpotList(spotList: shops)
            } else {
                view.setSpotList(spotList: [SpotEntityProtocol]())
            }
            complete()
        }
        )
    }
}
