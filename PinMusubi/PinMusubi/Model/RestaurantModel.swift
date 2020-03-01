//
//  RestaurantModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/24.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

class RestaurantModel: SpotModelProtocol {
    typealias Category = MKLocalSearchRequestParameter.Category.Restaurant

    var pinPoint: CLLocationCoordinate2D

    init(pinPoint: CLLocationCoordinate2D) {
        self.pinPoint = pinPoint
    }

    func fetchSpotList(region: Double, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        var restaurantList = [RestaurantEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchRestaurantList", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchGourmetShops {
                $0.forEach {
                    restaurantList.append(
                        RestaurantEntity(
                            name: $0.name,
                            category: $0.genre.name,
                            imageURLString: $0.photo.pc.m,
                            generalImage: nil,
                            latitude: CLLocationDegrees($0.lat)!,
                            longitude: CLLocationDegrees($0.lng)!,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: CLLocationDegrees($0.lat),
                                longitude: CLLocationDegrees($0.lng)
                            ),
                            price: $0.budget.average,
                            access: $0.access,
                            address: $0.address,
                            open: $0.open,
                            close: $0.close,
                            phoneNumber: nil,
                            url: self.createSpotURL(
                                URLString: $0.urls.pc
                            )
                        )
                    )
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchPlaces(categories: Category.allCases, region: region) {
                $0.forEach {
                    restaurantList.append(
                        RestaurantEntity(
                            name: $0.name,
                            category: $0.category.inName(),
                            imageURLString: nil,
                            generalImage: $0.category.rawValue,
                            latitude: $0.latitude,
                            longitude: $0.longitude,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: $0.latitude,
                                longitude: $0.longitude
                            ),
                            price: nil,
                            access: nil,
                            address: $0.address,
                            open: nil,
                            close: nil,
                            phoneNumber: $0.phoneNumber,
                            url: $0.url
                        )
                    )
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            let sortedRestaurantList = restaurantList.sorted(by: { $0.distance < $1.distance })
            completion(sortedRestaurantList, .restaurant)
        }
    }

    func createSpotURL(URLString: String) -> URL? {
        guard let affiliateURLString = KeyManager().getValue(key: "HOT PEPPER Affiliate URL") as? String else { return nil }
        return URL(string: "\(affiliateURLString)\(URLString)")
    }

    private func fetchGourmetShops(
        keyword: String? = nil,
        id: String? = nil,
        order: String? = nil,
        range: String? = HotpepperRequestParameter.Range._3000.rawValue,
        count: String? = HotpepperRequestParameter.Count._50.rawValue,
        completion: @escaping ([HotpepperShop]) -> Void
    ) {
        // HOTPEPPER グルメサーチ API
        let client = HotpepperClient()
        let request = HotpepperAPI.GourmetSearch(
            keyword: keyword,
            id: id,
            latitude: String(pinPoint.latitude),
            longitude: String(pinPoint.longitude),
            range: range,
            order: order,
            count: count
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                completion(response.results.shop ?? [])

            case let .failure(error):
                print("error \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
