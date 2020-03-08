//
//  SpotModelProtocol.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import MapKit

protocol SpotModelProtocol {
    var pinPoint: CLLocationCoordinate2D { get set }

    func fetchSpotList(region: Double, completion: @escaping ([SpotEntity], SpotType) -> Void)

    func createSpotURL(URLString: String) -> URL?
}

extension SpotModelProtocol {
    func getDitance(pinPoint: CLLocationCoordinate2D, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) -> Double {
        guard let latitude = latitude else { return -1 }
        guard let longitude = longitude else { return -1 }

        let pinLocation = CLLocation(latitude: pinPoint.latitude, longitude: pinPoint.longitude)
        let placeLocation = CLLocation(latitude: latitude, longitude: longitude)
        return placeLocation.distance(from: pinLocation)
    }

    func fetchPlaces<T: MKLocalSearchCategory>(categories: [T], region: Double, completion: @escaping ([MKLocalSearchResponse<T>]) -> Void) {
        var response = [MKLocalSearchResponse<T>]()

        // MKLocalSearch プレイス検索
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchAllPlace")
        categories.forEach { category in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = category.getSearchName()
                request.region = MKCoordinateRegion(center: self.pinPoint, latitudinalMeters: region, longitudinalMeters: region)

                MKLocalSearchClient.search(request: request) { result in
                    switch result {
                    case .success(let mapItems):
                        mapItems.forEach {
                            response.append(
                                MKLocalSearchResponse<T>(
                                    name: $0.name ?? "",
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
}

enum ResponseStatus {
    case success
    case error
}
