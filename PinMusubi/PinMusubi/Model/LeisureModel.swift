//
//  LeisureModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

class LeisureModel: SpotModelProtocol {
    typealias Category = MKLocalSearchRequestParameter.Category.Leisure

    var pinPoint: CLLocationCoordinate2D

    init(pinPoint: CLLocationCoordinate2D) {
        self.pinPoint = pinPoint
    }

    func fetchSpotList(region: Double, completion: @escaping ([SpotEntity], SpotType) -> Void) {
        var leisureList = [SpotEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchLeisureList")

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchLeisureList {
                $0.forEach {
                    leisureList.append(
                        SpotEntity(
                            name: $0.name,
                            category: $0.property.genre[0].name,
                            imageURLString: $0.property.leadImage,
                            latitude: self.getCoordinate(coordinates: $0.geometry.coordinates).0,
                            longitude: self.getCoordinate(coordinates: $0.geometry.coordinates).1,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: self.getCoordinate(coordinates: $0.geometry.coordinates).0,
                                longitude: self.getCoordinate(coordinates: $0.geometry.coordinates).1
                            ),
                            address: $0.property.address,
                            phoneNumber: $0.property.tel1,
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
                    leisureList.append(
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
            let filteredList = leisureList.filter { $0.distance < region }
            let sortedList = filteredList.sorted(by: { $0.distance < $1.distance })
            completion(sortedList, .leisure)
        }
    }

    func createSpotURL(URLString: String) -> URL? {
        return URL(string: URLString)
    }

    private func fetchLeisureList(
        query: String? = nil,
        id: String? =  nil,
        sort: String? =  YOLPRequestParameter.Sort.geo.rawValue,
        results: String? =  YOLPRequestParameter.Results.result50.rawValue,
        dist: String? =  YOLPRequestParameter.Dist.dist3000.rawValue,
        gc: String? =  YOLPRequestParameter.GC.Leisure.allCases.reduce("") { $0 + "," + $1.rawValue },
        completion: @escaping ([YOLPFeature]) -> Void
    ) {
        // YOLP Local Search API
        let client = YOLPClient()
        let request = YOLPAPI.LocalSearch(
            query: query,
            id: id,
            sort: sort,
            results: results,
            latitude: String(pinPoint.latitude),
            longitude: String(pinPoint.longitude),
            dist: dist,
            gc: gc
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                completion(response.feature ?? [])

            case let .failure(error):
                print("error \(error.localizedDescription)")
                completion([])
            }
        }
    }

    private func getCoordinate(coordinates: String) -> (CLLocationDegrees, CLLocationDegrees) {
        let coordinateArray = coordinates.components(separatedBy: ",")
        if let latitude = CLLocationDegrees(coordinateArray[1]),
            let longitude = CLLocationDegrees(coordinateArray[0]) {
            return (latitude, longitude)
        } else {
            return (0.0, 0.0)
        }
    }
}
