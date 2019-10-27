//
//  StationModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public protocol StationModelProtcol{
    /// コンストラクタ
    init()

    /// 駅情報を取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    func fetchStationList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([Station], ResponseStatus) -> Void)
}

public class StationModel: StationModelProtcol {
    /// コンストラクタ
    public required init() {}
    
    //// 駅情報を取得
    /// - Parameter pinPoint: ピンの位置情報
    /// - Parameter completion: 完了ハンドラ
    public func fetchStationList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([Station], ResponseStatus) -> Void) {
        let url = "http://express.heartrails.com/api/json"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "getStations"),
            URLQueryItem(name: "x", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "y", value: "\(pinPoint.longitude)")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let jsonData = data else { return }
            do {
                let station = try JSONDecoder().decode(StationEntity.self, from: jsonData)
                completion(station.response.station, .success)
            } catch {
                print(error)
                completion([], .error)
            }
        }
        task.resume()
    }
}
