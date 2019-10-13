//
//  PointsInfomationModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を処理するモデルのプロトコル
public protocol PointsInfomationModelProtocol {
    /// コンストラクタ
    init()

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func calculateTransferTime(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, complete: @escaping ([String], [Int]) -> Void)
}

/// マップ上の地点間の情報を処理するモデル
public class PointsInfomationModel: PointsInfomationModelProtocol {
    /// コンストラクタ
    public required init() {}

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter complete: 完了ハンドラ
    public func calculateTransferTime(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, complete: @escaping ([String], [Int]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var pointNameList = [String]()
        var transferTimeList = [Int].init(repeating: Int(), count: settingPoints.count)

        // 地点名の設定
        for settingPoint in settingPoints {
            pointNameList.append(settingPoint.name)
        }

        // 移動時間の設定
        for settingPoint in settingPoints {
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
            request.transportType = .automobile
            // MKDirectionsにrequestを設定し、移動時間を計算
            let directions = MKDirections(request: request)
            dispatchGroup.enter()
            directions.calculate(completionHandler: { response, error -> Void in
                // 地点名と対応する移動時間を設定
                guard let index = pointNameList.firstIndex(of: settingPoint.name) else { return }
                if let routes = response?.routes {
                    if error != nil || routes.isEmpty {
                        transferTimeList[index] = -1
                    } else {
                        transferTimeList[index] = Int( routes[0].expectedTravelTime / 60)
                    }
                } else {
                    transferTimeList[index] = -1
                }
                dispatchGroup.leave()
            }
            )
        }

        dispatchGroup.notify(queue: .main) {
            complete(pointNameList, transferTimeList)
        }
    }
}