//
//  RestaurantSpotsModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/24.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

internal class RestaurantSpotsModel: SpotModelProtocol {
    private var apiKey = ""

    internal required init() {
        guard let apiKey = KeyManager().getValue(key: "Recruit API Key") as? String else { return }
        self.apiKey = apiKey
    }

    internal func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        let url = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lng", value: "\(pinPoint.longitude)"),
            URLQueryItem(name: "range", value: "5"),
            URLQueryItem(name: "order", value: "1"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "format", value: "json")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else { return }
            do {
                let restaurantSpot = try JSONDecoder().decode(RestaurantSpotEntity.self, from: jsonData)
                completion(restaurantSpot.results.shop, .restaurant)
            } catch {
                completion([], .restaurant)
            }
        }
        task.resume()
    }
}
