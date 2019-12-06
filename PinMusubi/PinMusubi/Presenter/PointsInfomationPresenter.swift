//
//  PointsInfomationPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を渡すプレゼンターのプロトコル
public protocol PointsInfomationPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: PointInfomationCell, modelType model: PointsInfomationModelProtocol.Type)

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D)

    /// 設定地点とピンの地点の乗換案内URLを取得
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D)
}

/// マップ上の地点間の情報を渡すプレゼンター
public class PointsInfomationPresenter: PointsInfomationPresenterProrocol {
    private weak var view: PointInfomationCell?
    private let model: PointsInfomationModelProtocol?

    /// コンストラクタ
    public required init(view: PointInfomationCell, modelType model: PointsInfomationModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func getTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.calculateTransferTime(settingPoint: settingPoint, pinPoint: pinPoint) { transferTime in
            view.setTransferTime(transferTime: transferTime)
        }
    }

    public func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.getTransportationGuide(settingPoint: settingPoint, pinPoint: pinPoint) { urlString, fromStationName, toStationName, status in
            view.setTransportationGuideURLString(urlString: urlString, fromStationName: fromStationName, toStationName: toStationName, status: status)
        }
    }
}
