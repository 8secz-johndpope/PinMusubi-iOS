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

    /// 乗換案内情報URLの文字列を取得
    /// - Parameter fromStation: 出発駅
    /// - Parameter toStation: 到着駅
    /// - Parameter complete: 完了ハンドラß
    func getTransferGuide(fromStation: String, toStation: String, complete: @escaping (String, ResponseStatus) -> Void)
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
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    /// - Parameter complete: 完了ハンドラ
    public func calculateTransferTime(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, complete: @escaping ([String], [Int]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var idList = [String]()
        var pointNameList = [String]()
        var transferTimeList = [Int].init(repeating: Int(), count: settingPoints.count)
        var pointCount = 1

        // 地点名の設定
        for settingPoint in settingPoints {
            idList.append(settingPoint.id)
            if settingPoint.name != "" {
                pointNameList.append(settingPoint.name)
            } else {
                pointNameList.append("地点" + String(pointCount))
            }
            pointCount += 1
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
                guard let index = idList.firstIndex(of: settingPoint.id) else { return }
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

    public func getTransferGuide(fromStation: String, toStation: String, complete: @escaping (String, ResponseStatus) -> Void) {
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
