//
//  HotelModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

class HotelModel: SpotModelProtocol {
    typealias Category = MKLocalSearchRequestParameter.Category.Hotel

    var pinPoint: CLLocationCoordinate2D

    init(pinPoint: CLLocationCoordinate2D) {
        self.pinPoint = pinPoint
    }

    func fetchSpotList(completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        var hotelList = [HotelEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchHotelList", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchSimpleHotels {
                $0.forEach {
                    guard let hotel = $0.first?.hotelBasicInfo else { return }
                    hotelList.append(
                        HotelEntity(
                            name: hotel.hotelName,
                            category: Category.hotel.inName(),
                            thumbnailURLString: hotel.hotelThumbnailURL,
                            imageURLString: hotel.hotelImageURL,
                            generalImage: nil,
                            latitude: hotel.latitude,
                            longitude: hotel.longitude,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: hotel.latitude,
                                longitude: hotel.longitude
                            ),
                            reviewAverage: self.setReviewAverage(
                                reviewAverage: hotel.reviewAverage
                            ),
                            special: hotel.hotelSpecial,
                            access: hotel.access,
                            address: hotel.address1 + hotel.address2,
                            phoneNumber: hotel.telephoneNo,
                            url: self.createSpotURL(
                                URLString: hotel.hotelInformationURL ?? ""
                            )
                        )
                    )
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchPlaces(categories: Category.allCases) {
                $0.forEach {
                    hotelList.append(
                        HotelEntity(
                            name: $0.name,
                            category: $0.category?.inName(),
                            thumbnailURLString: nil,
                            imageURLString: nil,
                            generalImage: $0.category?.rawValue,
                            latitude: $0.latitude!,
                            longitude: $0.longitude!,
                            distance: self.getDitance(
                                pinPoint: self.pinPoint,
                                latitude: $0.latitude,
                                longitude: $0.longitude
                            ),
                            reviewAverage: self.setReviewAverage(
                                reviewAverage: nil
                            ),
                            special: nil,
                            access: nil,
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
            let sortedHotelList = hotelList.sorted(by: { $0.distance < $1.distance })
            completion(sortedHotelList, .hotel)
        }
    }

    func createSpotURL(URLString: String) -> URL? {
        return URL(string: URLString)
    }

    private func fetchSimpleHotels(
        searchRadius: String? = RakutenTravelRequestParameter.SearchRadius.range3000.rawValue,
        squeezeCondition: String? = nil,
        completion: @escaping ([[RakutenTravelHotel]]) -> Void
    ) {
        // Rakuten Travel Simple Hotel Search API
        let client = RakutenTravelClient()
        let request = RakutenTravelAPI.SimpleHotelSearch(
            latitude: String(pinPoint.latitude),
            longitude: String(pinPoint.longitude),
            searchRadius: searchRadius,
            squeezeCondition: squeezeCondition
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                completion(response.hotels)

            case let .failure(error):
                print("error \(error.localizedDescription)")
                completion([])
            }
        }
    }

    private func fetchSimpleHotelByNo(
        hotelNo: String,
        hotelThumbnailSize: String? = RakutenTravelRequestParameter.HotelThumbnailSize.middle.rawValue,
        responseType: String? = RakutenTravelRequestParameter.ResponseType.large.rawValue,
        completion: @escaping (RakutenTravelHotel?) -> Void
    ) {
        // Rakuten Travel Hotel Detail Search API
        let client = RakutenTravelClient()
        let request = RakutenTravelAPI.HotelDetailSearch(
            hotelNo: hotelNo,
            hotelThumbnailSize: hotelThumbnailSize,
            responseType: responseType
        )

        client.send(request: request) { result in
            switch result {
            case let .success(response):
                completion(response.hotels.first?.first)

            case let .failure(error):
                print("error \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    private func setReviewAverage(reviewAverage: Double?) -> String {
        if let reviewAverage = reviewAverage {
            return "レビュー評価：\(String(reviewAverage))"
        } else {
            return "レビュー評価：なし"
        }
    }

    private func setNearestStation(nearestStation: String?) -> String {
        if let nearestStation = nearestStation {
            return "\(nearestStation)駅近く"
        } else {
            return "最寄駅情報なし"
        }
    }
}
