//
//  PointsInfomationPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import MapKit

/// マップ上の地点間の情報を渡すプレゼンターのプロトコル
public protocol PointsInfomationPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type)

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getPointsInfomation(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D)
}

/// マップ上の地点間の情報を渡すプレゼンター
public class PointsInfomationPresenter: PointsInfomationPresenterProrocol {
    private weak var view: PointsInfomationAnnotationView?
    private let model: PointsInfomationModelProtocol?

    /// コンストラクタ
    public required init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func getPointsInfomation(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }
        guard let view = view else { return }
        model.calculateTransferTime(settingPoints: settingPoints, pinPoint: pinPoint, complete: { pointNameList, transferTimeList in
            view.reloadPointsInfoTableView(pointNameList: pointNameList, transferTimeList: transferTimeList)
        }
        )
    }
}
