//
//  SettingBasePointsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/08.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 検索条件を設定するビジネスモデルのプロトコル
public protocol SettingBasePointsModelProtocol {
    /// コンストラクタ
    init()

    /// 住所等から地理座標を設定
    /// - Parameter address: 住所等情報
    /// - Parameter complete: 完了ハンドラ
    func geocode(completion: MKLocalSearchCompletion, complete: @escaping (CLLocationCoordinate2D?) -> Void)

    /// 中間地点を計算して返却する
    func calculateHalfPoint(settingPoints: [SettingPointEntity]) -> CLLocationCoordinate2D
}

/// 検索条件を設定するビジネスモデル
public class SettingBasePointsModel: SettingBasePointsModelProtocol {
    /// コンストラクタ
    public required init() {}

    /// 場所情報から地理座標を設定
    /// - Parameter completion: 場所情報
    /// - Parameter complete: 完了ハンドラ
    public func geocode(completion: MKLocalSearchCompletion, complete: @escaping (CLLocationCoordinate2D?) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if error == nil {
                guard let response = response else { return }
                let coordinate = response.mapItems[0].placemark.coordinate
                complete(coordinate)
            } else {
                complete(nil)
            }
        }
    }

    /// 中間地点を計算して返却
    /// - Parameter settingPoints: 設定地点リスト
    public func calculateHalfPoint(settingPoints: [SettingPointEntity]) -> CLLocationCoordinate2D {
        var halfwayPoint = CLLocationCoordinate2D()
        for settingPoint in settingPoints {
            halfwayPoint.latitude += settingPoint.latitude
            halfwayPoint.longitude += settingPoint.longitude
        }
        halfwayPoint.latitude /= Double(settingPoints.count)
        halfwayPoint.longitude /= Double(settingPoints.count)
        return halfwayPoint
    }
}
