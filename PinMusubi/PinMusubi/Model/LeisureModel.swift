//
//  LeisureModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

internal class LeisureModel: SpotModelProtocol {
    private var appid = ""

    internal required init() {
        guard let appid = KeyManager().getValue(key: "Yolp API Key") as? String else { return }
        self.appid = appid
    }

    internal func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        let url = "https://map.yahooapis.jp/search/local/V1/localSearch"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "appid", value: appid),
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lon", value: "\(pinPoint.longitude)"),
            URLQueryItem(name: "gc", value: "0301,0302,0303,0305,0307,0308"),
            URLQueryItem(name: "dist", value: "20"),
            URLQueryItem(name: "results", value: "100"),
            URLQueryItem(name: "sort", value: "geo"),
            URLQueryItem(name: "image", value: "true"),
            URLQueryItem(name: "device", value: "mobile"),
            URLQueryItem(name: "output", value: "json")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else { return }
            do {
                let leisureInfo = try JSONDecoder().decode(LeisureEntity.self, from: jsonData)
                var features = [Feature]()
                for feature in leisureInfo.feature where !feature.property.genre[0].code.contains("0304") {
                    features.append(feature)
                }
                completion(features, .leisure)
            } catch {
                completion([], .leisure)
            }
        }
        task.resume()
    }
}
