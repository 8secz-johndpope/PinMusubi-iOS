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
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportation: Transportation, complete: @escaping (Int) -> Void)

    /// 乗換案内情報URLの文字列を取得
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, String, String) -> Void)
}

/// マップ上の地点間の情報を処理するモデル
class PointsInfomationModel: PointsInfomationModelProtocol {
    /// コンストラクタ
    required init() {}

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter transportation: 移動手段
    /// - Parameter complete: 完了ハンドラ
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, transportation: Transportation, complete: @escaping (Int) -> Void) {
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
        // 移動手段の設定
        switch transportation {
        case .walk:
            request.transportType = .walking
            fetchTravelTimeByMKDirections(request: request) {
                complete($0)
            }

        case .bicycle:
            request.transportType = .walking
            fetchTravelTimeBySelf(request: request) {
                complete($0)
            }

        case .car:
            request.transportType = .automobile
            fetchTravelTimeByMKDirections(request: request) {
                complete($0)
            }

        case .train:
            request.transportType = .walking
            fetchTravelTimeByMKDirections(request: request) {
                complete($0)
            }
        }
    }

    private func fetchTravelTimeByMKDirections(request: MKDirections.Request, complete: @escaping (Int) -> Void) {
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

    private func fetchTravelTimeBySelf(request: MKDirections.Request, complete: @escaping (Int) -> Void) {
        // MKDirectionsにrequestを設定し、移動時間を計算
        let directions = MKDirections(request: request)
        directions.calculate { response, error -> Void in
            if let routes = response?.routes {
                if error != nil || routes.isEmpty {
                    complete(-1)
                } else {
                    guard let distance = routes.first?.distance else {
                        complete(-1)
                        return
                    }
                    let minuteSpeed: Double = 250
                    complete(Int(distance / minuteSpeed))
                }
            } else {
                complete(-1)
            }
        }
    }

    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, String, String) -> Void) {
        let fromPoint = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
        let toPoint = pinPoint

        var fromStation = ""
        var toStation = ""

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "transportationGuideQueue", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchStationList(
                latitude: fromPoint.latitude,
                longitude: fromPoint.longitude
            ) {
                self.fetchCorrectStationName(stationName: $0.first?.name ?? "", point: fromPoint) {
                    fromStation = $1 == .success ? $0 : ""
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchStationList(
                latitude: toPoint.latitude,
                longitude: toPoint.longitude
            ) {
                self.fetchCorrectStationName(stationName: $0.first?.name ?? "", point: toPoint) {
                    toStation = $1 == .success ? $0 : ""
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.fetchTransferGuide(fromStation: fromStation, toStation: toStation) {
                complete($0, fromStation, toStation)
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

    private func fetchTransferGuide(fromStation: String, toStation: String, complete: @escaping (String) -> Void) {
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
                    complete(resourceURI)
                } else {
                    complete("")
                }

            case .failure(_):
                complete("")
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
