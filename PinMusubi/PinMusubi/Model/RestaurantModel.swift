//
//  RestaurantModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/24.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import MapKit

class RestaurantModel: SpotModelProtocol {
    var pinPoint: CLLocationCoordinate2D?

    required init() {}

    func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        self.pinPoint = pinPoint
        var restaurantList = [RestaurantEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchSpotList", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchGourmetShop {
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
                                pinPoint: pinPoint,
                                latitude: CLLocationDegrees($0.lat),
                                longitude: CLLocationDegrees($0.lng)
                            ),
                            price: $0.budget.average,
                            access: $0.access,
                            address: $0.address,
                            open: $0.open,
                            close: $0.close,
                            phoneNumber: nil,
                            url: self.createHotpepperURL(
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
            self.fetchAllRestaurant {
                $0.forEach {
                    restaurantList.append(
                        RestaurantEntity(
                            name: $0.name,
                            category: $0.category?.inName(),
                            imageURLString: nil,
                            generalImage: UIImage(named: $0.category?.rawValue ?? ""),
                            latitude: $0.latitude!,
                            longitude: $0.longitude!,
                            distance: self.getDitance(
                                pinPoint: pinPoint,
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

    private func fetchGourmetShop(completion: @escaping ([HotpepperShop]) -> Void) {
        // HOTPEPPER グルメサーチ API
        let client = HotpepperClient()
        let request = HotpepperAPI.GourmetSearch(
            keyword: nil,
            id: nil,
            latitude: String(pinPoint!.latitude),
            longitude: String(pinPoint!.longitude),
            range: HotpepperRequestParameter.Range._3000.rawValue,
            order: nil,
            count: HotpepperRequestParameter.Count._50.rawValue
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                if let shop = response.results.shop {
                    completion(shop)
                } else {
                    completion([])
                }

            case .failure(_):
                completion([])
            }
        }
    }

    private func fetchAllRestaurant(completion: @escaping ([MKLocalSearchResponse<MKLocalSearchRequestParameter.Category.Restaurant>]) -> Void) {
        var response = [MKLocalSearchResponse<MKLocalSearchRequestParameter.Category.Restaurant>]()

        // MKLocalSearch プレイス検索
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchAllRestaurant", attributes: .concurrent)
        MKLocalSearchRequestParameter.Category.Restaurant.allCases.forEach { category in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) { [weak self] in
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = category.inName()
                request.region = MKCoordinateRegion(center: self!.pinPoint!, latitudinalMeters: 3_000.0, longitudinalMeters: 3_000.0)

                MKLocalSearchClient.search(request: request) { result in
                    switch result {
                    case .success(let mapItems):
                        mapItems.forEach {
                            response.append(
                                MKLocalSearchResponse<MKLocalSearchRequestParameter.Category.Restaurant>(
                                    name: $0.name,
                                    category: category,
                                    latitude: $0.placemark.coordinate.latitude,
                                    longitude: $0.placemark.coordinate.longitude,
                                    address: $0.placemark.title,
                                    url: $0.url,
                                    phoneNumber: $0.phoneNumber
                                )
                            )
                        }

                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(response)
        }
    }

    private func fetchRestaurant(
        category: MKLocalSearchRequestParameter.Category.Restaurant,
        completion: @escaping ([MKLocalSearchResponse<MKLocalSearchRequestParameter.Category.Restaurant>]) -> Void
    ) {
        var response = [MKLocalSearchResponse<MKLocalSearchRequestParameter.Category.Restaurant>]()

        // MKLocalSearch プレイス検索
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = category.inName()
        request.region = MKCoordinateRegion(center: pinPoint!, latitudinalMeters: 3_000.0, longitudinalMeters: 3_000.0)

        MKLocalSearchClient.search(request: request) { result in
            switch result {
            case .success(let mapItems):
                mapItems.forEach {
                    response.append(
                        MKLocalSearchResponse(
                            name: $0.name,
                            category: category,
                            latitude: $0.placemark.coordinate.latitude,
                            longitude: $0.placemark.coordinate.longitude,
                            address: $0.placemark.title,
                            url: $0.url,
                            phoneNumber: $0.phoneNumber
                        )
                    )
                }
                completion(response)

            case .failure(let error):
                print("error \(error.localizedDescription)")
                completion([])
            }
        }
    }

    private func createHotpepperURL(URLString: String) -> URL? {
        guard let affiliateURLString = KeyManager().getValue(key: "HOT PEPPER Affiliate URL") as? String else { return nil }
        return URL(string: "\(affiliateURLString)\(URLString)")
    }
}
