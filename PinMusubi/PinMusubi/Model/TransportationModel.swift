//
//  TransportationModel.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import MapKit

class TransportationModel: SpotModelProtocol {
    typealias Category = MKLocalSearchRequestParameter.Category.Transportation

    var pinPoint: CLLocationCoordinate2D

    init(pinPoint: CLLocationCoordinate2D) {
        self.pinPoint = pinPoint
    }

    func fetchSpotList(region: Double, completion: @escaping ([SpotEntity], SpotType) -> Void) {
        var transportationList = [SpotEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchTrasportationList")

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchPlaces(categories: Category.allCases, region: region) {
                $0.forEach {
                    transportationList.append(
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
            let filteredList = transportationList.filter { $0.distance < region }
            let sortedList = filteredList.sorted(by: { $0.distance < $1.distance })
            completion(sortedList, .transportation)
        }
    }

    func createSpotURL(URLString: String) -> URL? {
        return URL(string: URLString)
    }
}
