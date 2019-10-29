//
//  StationSpotPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/30.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 駅の一覧を表示するプレゼンターのプロトコル
public protocol StationSpotPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: SpotListCollectionViewCell, modelType model: StationModelProtcol.Type)

    func fetchStationList(interestPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol]) -> Void)
}

/// 駅の一覧を表示するプレゼンター
public class StationSpotPresenter: StationSpotPresenterProrocol {
    private weak var view: SpotListCollectionViewCell?
    private let model: StationModelProtcol?

    /// コンストラクタ
    public required init(view: SpotListCollectionViewCell, modelType model: StationModelProtcol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 駅情報を取得
    /// - Parameter interestPoint: 興味のある地点
    /// - Parameter completion: 完了ハンドラ
    public func fetchStationList(interestPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol]) -> Void) {
        guard let model = model else { return }
        model.fetchStationList(pinPoint: interestPoint, completion: { stations, status in
            if status == .success {
                completion(stations)
            } else {
                completion([SpotEntityProtocol]())
            }
        }
        )
    }
}
