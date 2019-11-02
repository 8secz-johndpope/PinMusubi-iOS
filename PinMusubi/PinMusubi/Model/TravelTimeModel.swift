//
//  TravelTimeModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を処理するモデルのプロトコル
public protocol TravelTimeModelProtocol {
    /// コンストラクタ
    init()

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, complete: @escaping (Int) -> Void)
}

/// マップ上の地点間の情報を処理するモデル
public class TravelTimeModel: TravelTimeModelProtocol {
    /// コンストラクタ
    public required init() {}

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter complete: 完了ハンドラ
    public func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportType: MKDirectionsTransportType, complete: @escaping (Int) -> Void) {
        // PlaceMarkに出発地と目的地の座標を設定
        let fromCoordinate = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
        let fromPlace = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let toPlace = MKPlacemark(coordinate: pinPoint, addressDictionary: nil)
        // MKDirectionsRequestに出発地と目的地を設定
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: fromPlace)
        request.destination = MKMapItem(placemark: toPlace)
        // 複数経路の検索を有効に設定
        request.requestsAlternateRoutes = true
        // 移動手段を車に設定
        request.transportType = transportType
        // MKDirectionsにrequestを設定し、移動時間を計算
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { response, error -> Void in
            // 地点名と対応する移動時間を設定
            if let routes = response?.routes {
                if error != nil {
                    complete(-1)
                } else if routes.isEmpty {
                    complete(-2)
                } else {
                    complete(Int( routes[0].expectedTravelTime / 60))
                }
            } else {
                complete(-1)
            }
        }
        )
    }
}
