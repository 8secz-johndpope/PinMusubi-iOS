//
//  RestaurantSpotsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/24.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

/// 成功・失敗
public enum ResponseStatus {
    /// 成功
    case success
    /// 失敗
    case error
}

/// リストの順序
public enum OrderType: String {
    /// 距離順
    case byDistance = "1"
    /// オススメ順
    case byRecomend = "4"
}

/// レストランのスポット情報を取得するModelのProtcol
public protocol RestaurantSpotsModelProtocol {
    /// コンストラクタ
    init()

    /// レストランのスポットを取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    func fetchRestaurantSpotList(pinPoint: CLLocationCoordinate2D, order: OrderType, completion: @escaping ([Shop], ResponseStatus) -> Void)
}

/// レストランのスポット情報を取得するModel
public class RestaurantSpotsModel: RestaurantSpotsModelProtocol {
    private var apiKey = ""

    /// コンストラクタ
    public required init() {
        guard let apiKey = KeyManager().getValue(key: "Recruit API Key") as? String else { return }
        self.apiKey = apiKey
    }

    /// レストランのスポットを取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    public func fetchRestaurantSpotList(pinPoint: CLLocationCoordinate2D, order: OrderType, completion: @escaping ([Shop], ResponseStatus) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lng", value: "\(pinPoint.longitude)"),
            URLQueryItem(name: "range", value: "5"),
            URLQueryItem(name: "order", value: order.rawValue),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let jsonData = data else { return }
            do {
                let restaurantSpot = try JSONDecoder().decode(RestaurantSpotEntity.self, from: jsonData)
                completion(restaurantSpot.results.shop, .success)
            } catch {
                print(error)
                completion([], .error)
            }
        }
        task.resume()
    }
}
