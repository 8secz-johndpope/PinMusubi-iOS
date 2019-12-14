//
//  SearchCriteriaModalViewPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import MapKit

/// 地点設定処理に関するPresenterのプロトコル
public protocol SettingBasePointsPresenterProtocol: AnyObject {
    /// コンストラクタ
    /// - Parameter view: SettingBasePointsView
    /// - Parameter model: SearchCriteriaModelProtocol
    init(view: SettingBasePointsView, modelType model: SettingBasePointsModelProtocol.Type)

    /// 場所情報から座標を取得
    /// - Parameter completion: 場所情報
    /// - Parameter complete: 完了ハンドラ
    func getAddress(completion: MKLocalSearchCompletion, complete: @escaping (CLLocationCoordinate2D?) -> Void)

    /// 設定地点をもとにMapViewにピン等を設置
    /// - Parameter settingPoints: 設定地点リスト
    func setPointsOnMapView(settingPoints: [SettingPointEntity])
}

/// 地点設定処理に関するPresenter
public class SettingBasePointsPresenter: SettingBasePointsPresenterProtocol {
    private weak var view: SettingBasePointsView?
    private let model: SettingBasePointsModelProtocol?

    public required init(view: SettingBasePointsView, modelType model: SettingBasePointsModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    public func getAddress(completion: MKLocalSearchCompletion, complete: @escaping (CLLocationCoordinate2D?) -> Void) {
        model?.geocode(completion: completion) { coordinate in
            complete(coordinate)
        }
    }

    public func setPointsOnMapView(settingPoints: [SettingPointEntity]) {
        guard let model = model else { return }
        guard let view = view else { return }
        guard let delegate = view.delegate else { return }
        delegate.setPin(settingPoints: settingPoints, halfwayPoint: model.calculateHalfPoint(settingPoints: settingPoints))
    }
}
