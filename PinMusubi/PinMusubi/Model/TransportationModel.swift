//
//  TransportationModel.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/16.
//  Copyright © 2020 naipaka. All rights reserved.
//

import CoreLocation

internal class TransportationModel: SpotModelProtocol {
    internal required init() {}

    internal func fetchSpotList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol], SpotType) -> Void) {
        var transportationList = [SpotEntityProtocol]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "transportationQueue", attributes: .concurrent)

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchStationList(pinPoint: pinPoint) { stationList in
                stationList.forEach {
                    transportationList.append($0)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.fetchBusStopList(pinPoint: pinPoint) { busStopList in
                busStopList.forEach {
                    transportationList.append($0)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(self.sortSpot(transportations: transportationList), .transportation)
        }
    }

    internal func fetchStationList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol]) -> Void) {
        let url = "http://express.heartrails.com/api/json"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "getStations"),
            URLQueryItem(name: "y", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "x", value: "\(pinPoint.longitude)")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else { return }
            do {
                let station = try JSONDecoder().decode(StationEntity.self, from: jsonData)
                completion(station.response.station)
            } catch {
                completion([])
            }
        }
        task.resume()
    }

    internal func fetchBusStopList(pinPoint: CLLocationCoordinate2D, completion: @escaping ([SpotEntityProtocol]) -> Void) {
        let url = "https://livlog.xyz/busstop/getBusStop"
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "lng", value: "\(pinPoint.longitude)")
        ]
        guard let urlRequest = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let jsonData = data else { return }
            do {
                let busStops = try JSONDecoder().decode([BusStopEntity].self, from: jsonData)
                completion(busStops)
            } catch {
                completion([])
            }
        }
        task.resume()
    }

    private func sortSpot(transportations: [SpotEntityProtocol]) -> [SpotEntityProtocol] {
        var sortedTransportations = transportations
        sortedTransportations.sort { before, after in
            var distanceBefore: Double = 0.0
            var distanceAfter: Double = 0.0
            if let before = before as? Station {
                guard let distance = Double(before.distance.dropLast()) else { return false }
                distanceBefore = Double(distance)
                if let after = after as? Station {
                    guard let distance = Double(after.distance.dropLast()) else { return false }
                    distanceAfter = Double(distance)
                } else if let after = after as? BusStopEntity {
                    distanceAfter = after.distance
                }
            } else if let before = before as? BusStopEntity {
                distanceBefore = before.distance
                if let after = after as? Station {
                    guard let distance = Double(after.distance.dropLast()) else { return false }
                    distanceAfter = Double(distance)
                } else if let after = after as? BusStopEntity {
                    distanceAfter = after.distance
                }
            }
            return distanceBefore < distanceAfter
        }
        return sortedTransportations
    }
}
