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

/// レストランのスポット情報を取得するModelのProtcol
public protocol RestaurantSpotsModelProtocol {
    /// コンストラクタ
    init()

    /// レストランのスポットを取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    func fetchRestaurantSpotList(pinPoint: CLLocationCoordinate2D, order: String, completion: @escaping ([RestaurantSpotEntity], ResponseStatus) -> Void)
}

/// レストランのスポット情報を取得するModel
public class RestaurantSpotsModel: RestaurantSpotsModelProtocol {
    /// コンストラクタ
    public required init() {}

    /// レストランのスポットを取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    public func fetchRestaurantSpotList(pinPoint: CLLocationCoordinate2D, order: String, completion: @escaping ([RestaurantSpotEntity], ResponseStatus) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: "4dc4229ac76d55f0"),
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lng", value: "\(pinPoint.longitude)"),
            URLQueryItem(name: "range", value: order),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let jsonData = data else { return }
            do {
                let restaurantSpotList = try JSONDecoder().decode([RestaurantSpotEntity].self, from: jsonData)
                completion(restaurantSpotList, .success)
            } catch {
                completion([], .error)
            }
        }
        task.resume()
    }
}
