//
//  HotelModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

internal class HotelModel: SpotModelProtocol {
    private var applicationId = ""
    private var affiliateId = ""

    internal required init() {
        guard let applicationId = KeyManager().getValue(key: "Rakuten API Key") as? String else { return }
        guard let affiliateId = KeyManager().getValue(key: "Rakuten Affiliate Id") as? String else { return }
        self.applicationId = applicationId
        self.affiliateId = affiliateId
    }

    internal func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        let url = "https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "applicationId", value: applicationId),
            URLQueryItem(name: "affiliateId", value: affiliateId),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "formatVersion", value: "1"),
            URLQueryItem(name: "datumType", value: "1"),
            URLQueryItem(name: "latitude", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "longitude", value: "\(pinPoint.longitude)"),
            URLQueryItem(name: "searchRadius", value: "1"),
            URLQueryItem(name: "allReturnFlag", value: "1")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else { return }
            do {
                let hotelInfo = try JSONDecoder().decode(HotelEntity.self, from: jsonData)
                completion(hotelInfo.hotels, .hotel)
            } catch {
                completion([], .hotel)
            }
        }
        task.resume()
    }
}
