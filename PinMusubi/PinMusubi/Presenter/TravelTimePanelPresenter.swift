//
//  TravelTimePanelPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 地点間の情報を渡すプレゼンターのプロトコル
internal protocol TravelTimePanelPresenterProtcol: AnyObject {
    /// コンストラクタ
    init(view: TravelTimePanelCell, modelType model: TravelTimeModelProtocol.Type)

    /// 設定地点とピンの地点との間の歩きでの移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getWalkingTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D)

    /// 設定地点とピンの地点との間の車での移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getDrivingTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D)

    /// 設定地点とピンの地点の乗換案内URLを取得
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D)
}

/// 地点間の情報を渡すプレゼンター
internal class TravelTimePanelPresenter: TravelTimePanelPresenterProtcol {
    private weak var view: TravelTimePanelCell?
    private let model: TravelTimeModelProtocol?

    /// コンストラクタ
    internal required init(view: TravelTimePanelCell, modelType model: TravelTimeModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    internal func getWalkingTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D) {
        guard let view = view else { return }
        guard let model = model else { return }
        model.calculateTransferTime(settingPoint: settingPoint, pinPoint: pinPoint, transportType: .walking) { walkingTime in
            view.setWalkingTime(walkingTime: walkingTime)
        }
    }

    internal func getDrivingTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D) {
        guard let view = view else { return }
        guard let model = model else { return }
        model.calculateTransferTime(settingPoint: settingPoint, pinPoint: pinPoint, transportType: .automobile) { drivingTime in
            view.setDrivingTime(drivingTime: drivingTime)
        }
    }

    internal func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D) {
        guard let view = view else { return }
        let pointsInfomation = PointsInfomationModel()
        pointsInfomation.getTransportationGuide(settingPoint: settingPoint, pinPoint: pinPoint) { urlString, fromStationName, toStationName, status in
            view.setTransportationGuide(urlString: urlString, fromStationName: fromStationName, toStationName: toStationName, status: status)
        }
    }
}
