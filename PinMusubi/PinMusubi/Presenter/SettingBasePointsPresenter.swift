//
//  SearchCriteriaModalViewPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

/// 地点設定処理に関するPresenterのプロトコル
public protocol SettingBasePointsPresenterProtocol: AnyObject {
    /// コンストラクタ
    /// - Parameter view: SettingBasePointsView
    /// - Parameter model: SearchCriteriaModelProtocol
    init(view: SettingBasePointsView, modelType model: SettingBasePointsModelProtocol.Type)

    /// 入力された住所をもとに入力チェックを行う
    /// - Parameter address: 入力された住所
    /// - Parameter complete: 完了ハンドラ
    func validateAddress(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void)

    /// 設定地点をもとにMapViewにピン等を設置
    /// - Parameter settingPoints: 設定地点リスト
    func setPointsOnMapView(settingPoints: [SettingPointEntity])
}

/// 地点設定処理に関するPresenter
public class SettingBasePointsPresenter: SettingBasePointsPresenterProtocol {
    private weak var view: SettingBasePointsView?
    private let model: SettingBasePointsModelProtocol?

    /// コンストラクタ
    /// - Parameter view: SettingBasePointsView
    /// - Parameter model: SearchCriteriaModelProtocol
    public required init(view: SettingBasePointsView, modelType model: SettingBasePointsModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    /// 入力された住所をもとに入力チェックを行う
    /// - Parameter address: 入力された住所
    /// - Parameter complete: 完了ハンドラ
    public func validateAddress(address: String, complete: @escaping (SettingPointEntity, AddressValidationStatus) -> Void) {
        model?.geocode(address: address, complete: { settingPoint, status in
            complete(settingPoint, status)
        }
        )
    }

    /// 設定地点をもとにMapViewにピン等を設置
    /// - Parameter settingPoints: 設定地点リスト
    public func setPointsOnMapView(settingPoints: [SettingPointEntity]) {
        guard let model = model else { return }
        guard let view = view else { return }
        guard let delegate = view.delegate else { return }
        delegate.setPin(settingPoints: settingPoints, halfwayPoint: model.calculateHalfPoint(settingPoints: settingPoints))
    }
}
