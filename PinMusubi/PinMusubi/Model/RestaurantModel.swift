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

    func fetchSpotList(region: Double, completion: @escaping ([SpotEntity], SpotType) -> Void) {
        var restaurantList = [SpotEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchRestaurantList")

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchGourmetShops {
                $0.forEach {
                    restaurantList.append(
                        SpotEntity(
                            name: $0.name,
                            category: $0.genre.name,
                            imageURLString: $0.photo.pc.l,
                            latitude: CLLocationDegrees($0.lat)!,
                            longitude: CLLocationDegrees($0.lng)!,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: CLLocationDegrees($0.lat),
                                longitude: CLLocationDegrees($0.lng)
                            ),
                            address: $0.address,
                            url: self.createSpotURL(
                                URLString: $0.urls.pc
                            ),
                            spotInfomation: $0
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
                        SpotEntity(
                            name: $0.name,
                            category: $0.category.getDisplayName(),
                            generalImageName: $0.category.rawValue,
                            latitude: $0.latitude,
                            longitude: $0.longitude,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: $0.latitude,
                                longitude: $0.longitude
                            ),
                            address: $0.address,
                            phoneNumber: $0.phoneNumber,
                            url: $0.url
                        )
                    )
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            let filteredList = restaurantList.filter { $0.distance < region }
            let sortedList = filteredList.sorted(by: { $0.distance < $1.distance })
            completion(sortedList, .restaurant)
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
