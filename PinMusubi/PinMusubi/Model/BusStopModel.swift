//
//  BusStopModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

/// 駅情報を取得するModelのProtocol
public protocol BusStopModelProtcol {
    /// コンストラクタ
    init()

    /// 駅情報を取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    func fetchBusStopList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([BusStop], ResponseStatus) -> Void)
}

/// 駅情報を取得するModel
public class BusStopModel: BusStopModelProtcol {
    /// コンストラクタ
    public required init() {}

    //// 駅情報を取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    public func fetchBusStopList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([BusStop], ResponseStatus) -> Void) {
        let url = "https://livlog.xyz/busstop/getBusStop"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lng", value: "\(pinPoint.longitude)")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let jsonData = data else { return }
            do {
                let busStop = try JSONDecoder().decode(BusStopEntity.self, from: jsonData)
                completion(busStop.busStop, .success)
            } catch {
                print(error)
                completion([], .error)
            }
        }
        task.resume()
    }
}
