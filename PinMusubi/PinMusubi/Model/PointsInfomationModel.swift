//
//  PointsInfomationModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を処理するモデルのプロトコル
protocol PointsInfomationModelProtocol {
    /// コンストラクタ
    init()

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (Int) -> Void)

    /// 乗換案内情報URLの文字列を取得
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, String, String, ResponseStatus) -> Void)
}

/// マップ上の地点間の情報を処理するモデル
class PointsInfomationModel: PointsInfomationModelProtocol {
    /// コンストラクタ
    required init() {}

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter complete: 完了ハンドラ
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (Int) -> Void) {
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
        directions.calculate { response, error -> Void in
            if let routes = response?.routes {
                if error != nil || routes.isEmpty {
                    complete(-1)
                } else {
                    complete(Int( routes[0].expectedTravelTime / 60))
                }
            } else {
                complete(-1)
            }
        }
    }

    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, String, String, ResponseStatus) -> Void) {
        let fromPoint = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
        let toPoint = pinPoint

        var fromStation = ""
        var toStation = ""

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "transportationGuideQueue", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            self?.fetchStationList(
                latitude: fromPoint.latitude,
                longitude: fromPoint.longitude
            ) {
                self?.fetchCorrectStationName(stationName: $0[0].name, point: fromPoint) {
                    fromStation = $1 == .success ? $0 : ""
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            self?.fetchStationList(
                latitude: toPoint.latitude,
                longitude: toPoint.longitude
            ) {
                self?.fetchCorrectStationName(stationName: $0[0].name, point: toPoint) {
                    toStation = $1 == .success ? $0 : ""
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.fetchTransferGuide(fromStation: fromStation, toStation: toStation) {
                complete($0, fromStation, toStation, $1)
            }
        }
    }

    private func fetchStationList(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ([HeartRailsExpressStation]) -> Void) {
        // Heart Rails Express API
        let client = HeartRailsExpressClient()
        let request = HeartRailsExpressAPI.GetStations(
            latitude: String(latitude),
            longitude: String(longitude)
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                completion(response.response.station ?? [])

            case let .failure(error):
                print("error \(error.localizedDescription)")
                completion([])
            }
        }
    }

    private func fetchTransferGuide(fromStation: String, toStation: String, complete: @escaping (String, ResponseStatus) -> Void) {
        // 駅すぱあと for web URL生成 API
        let client = EkispertClient()
        let request = EkispertAPI.SearchCourse(
            fromStation: fromStation,
            toStation: toStation
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                if let resourceURI = response.0?.resultSet.resourceURI {
                    complete(resourceURI, .success)
                } else if let error = response.0?.resultSet.error {
                    complete(error.message, .error)
                }

            case let .failure(error):
                complete(error.localizedDescription, .error)
            }
        }
    }

    private func fetchCorrectStationName(stationName: String, point: CLLocationCoordinate2D, complete: @escaping (String, ResponseStatus) -> Void) {
        // 前処理
        var correctStationName = stationName
        if stationName.contains("新線") {
            correctStationName = stationName.replacingOccurrences(of: "新線", with: "")
        }

        // 駅すぱあと 駅情報 API
        let client = EkispertClient()
        let request = EkispertAPI.SearchStation(name: correctStationName)

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                if let point = response.0?.resultSet.point {
                    complete(point.station.name, .success)
                } else if let points = response.1?.resultSet.point {
                    var diff = 1_000.0
                    points.forEach {
                        if let stationLat = Double($0.geoPoint.latiD), let stationLng = Double($0.geoPoint.longiD) {
                            let pointDiff = fabs(point.latitude - stationLat) + fabs(point.longitude - stationLng)
                            if diff > pointDiff {
                                correctStationName = $0.station.name
                                diff = pointDiff
                            }
                        }
                    }
                    complete(correctStationName, .success)
                } else if let error = response.0?.resultSet.error {
                    complete(error.message, .error)
                }

            case let .failure(error):
                complete(error.localizedDescription, .error)
            }
        }
    }
}
