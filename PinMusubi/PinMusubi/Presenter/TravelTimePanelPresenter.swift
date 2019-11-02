//
//  TravelTimePanelPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 地点間の情報を渡すプレゼンターのプロトコル
public protocol TravelTimePanelPresenterProtcol: AnyObject {
    /// コンストラクタ
    init(view: TravelTimePanelCell, modelType model: TravelTimeModelProtocol.Type)

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getPointsInfomation(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, complete: @escaping (Int) -> Void)
}

/// 地点間の情報を渡すプレゼンター
public class TravelTimePanelPresenter: TravelTimePanelPresenterProtcol {
    private weak var view: TravelTimePanelCell?
    private let model: TravelTimeModelProtocol?

    /// コンストラクタ
    public required init(view: TravelTimePanelCell, modelType model: TravelTimeModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func getPointsInfomation(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, complete: @escaping (Int) -> Void) {
        guard let model = model else { return }
        model.calculateTransferTime(settingPoint: settingPoint, pinPoint: pinPoint, transportType: transportType, complete: { travelTime in
            complete(travelTime)
        }
        )
    }
}
