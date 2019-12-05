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
    func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (Int) -> Void)

    /// 乗換案内情報URLの文字列を取得
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, ResponseStatus) -> Void)
}

/// マップ上の地点間の情報を処理するモデル
public class PointsInfomationModel: PointsInfomationModelProtocol {
    private var ekispertKey = ""

    /// コンストラクタ
    public required init() {
        guard let key = KeyManager().getValue(key: "Ekispert API Key") as? String else { return }
        self.ekispertKey = key
    }

    /// 設定地点とピンの地点との間の移動時間の計算
    /// - Parameter settingPoint: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter complete: 完了ハンドラ
    public func calculateTransferTime(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (Int) -> Void) {
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

    public func getTransportationGuide(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, complete: @escaping (String, ResponseStatus) -> Void) {
        let fromPoint = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
        let toPoint = pinPoint

        var fromStation = ""
        var toStation = ""

        let stationModel = StationModel()
        stationModel.fetchStationList(pinPoint: fromPoint) { fromStations, status in
            if status == .success && !fromStations.isEmpty {
                fromStation = fromStations[0].name
                stationModel.fetchStationList(pinPoint: toPoint) { [weak self] toStations, status in
                    if status == .success && !toStations.isEmpty {
                        toStation = toStations[0].name
                        self?.fetchTransferGuide(fromStation: fromStation, toStation: toStation) { urlString, status in
                            complete(urlString, status)
                        }
                    } else {
                        complete("ピンの近くの駅が見つかりませんでした。", .error)
                    }
                }
            } else {
                complete("「\(settingPoint.name)」近くの駅が見つかりませんでした。", .error)
            }
        }
    }

    private func fetchTransferGuide(fromStation: String, toStation: String, complete: @escaping (String, ResponseStatus) -> Void) {
        // リクエストURL生成
        let ekispertUrlString = "http://api.ekispert.jp/v1/json/search/course/light"
        guard var urlComponents = URLComponents(string: ekispertUrlString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: ekispertKey),
            URLQueryItem(name: "from", value: fromStation),
            URLQueryItem(name: "to", value: toStation),
            URLQueryItem(name: "contentsMode", value: "sp")
        ]
        guard let urlRequest = urlComponents.url else { return }

        // レスポンスJSONから乗換案内URLを取得
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let jsonData = data else { return }
            do {
                let transferGuide = try JSONDecoder().decode(TransferGuideEntity.self, from: jsonData)
                if let transferGuideURLString = transferGuide.resultSet.resourceURI {
                    complete(transferGuideURLString, .success)
                } else if let transferGuideError = transferGuide.resultSet.error {
                    complete(transferGuideError.message, .error)
                }
            } catch {
                complete("その他のエラー", .error)
                print(error)
            }
        }
        task.resume()
    }
}
