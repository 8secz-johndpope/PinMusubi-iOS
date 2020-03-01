//
//  MKLocalSearchClientTests.swift
//  PinMusubiTests
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import XCTest
import MapKit
@testable import PinMusubi

class MKLocalSearchClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testSearchPlace_ok() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSearchPlace_ok")
        let coordinate = CLLocationCoordinate2DMake(35.6598051, 139.7036661) // 渋谷ヒカリエ
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "電車"
        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)

        MKLocalSearchClient.search(request: request) { result in
            switch result {
            case .success(let mapItems):
                mapItems.forEach {
                    print("🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️")
                    print("name: \($0.name ?? "no name")")
                    print("phoneNumber: \($0.phoneNumber ?? "no phoneNumber")")
                    print("coordinate: \($0.placemark.coordinate.latitude) \($0.placemark.coordinate.longitude)")
                    print("address: \($0.placemark.address)")
                    print("url: \(String(describing: $0.url))")
                    print("title: \(String(describing: $0.placemark.title))")
                }

            case .failure(let error):
                print("🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️")
                print("error \(error.localizedDescription)")
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testSearchPlace_ok_all() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSearchPlace_ok_allCategory")
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        MKLocalSearchRequestParameter.Category.Restaurant.allCases.forEach { categry in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                let request = MKLocalSearch.Request()
                let coordinate = CLLocationCoordinate2DMake(35.6598051, 139.7036661)
                request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3_000.0, longitudinalMeters: 3_000.0)
                request.naturalLanguageQuery = categry.rawValue
                
                MKLocalSearchClient.search(request: request) { result in
                    print("🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉")
                    print("category: \(categry.rawValue)")
                    switch result {
                    case .success(let mapItems):
                        mapItems.forEach {
                            print("🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️")
                            print("name: \($0.name ?? "no name")")
                            print("phoneNumber: \($0.phoneNumber ?? "no phoneNumber")")
                            print("coordinate: \($0.placemark.coordinate.latitude) \($0.placemark.coordinate.longitude)")
                            print("address: \($0.placemark.address)")
                            print("url: \(String(describing: $0.url))")
                            print("title: \(String(describing: $0.placemark.title))")
                        }
                        
                    case .failure(let error):
                        print("🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️🙅‍♂️")
                        print("error \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            fetchExpectation?.fulfill()
            print("All Process Done!")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    func testSearchPlace_overview() {
        let fetchExpectation: XCTestExpectation? = expectation(description: "testSearchPlace_ok")
        
        let point = CLLocationCoordinate2D(latitude: 35.6598051, longitude: 139.7036661)
        let model = TransportationModel(pinPoint: point)
        
        model.fetchSpotList(region: 1000) { list, type in
            list.forEach {
                print("🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️")
                print($0.name)
                print($0.distance)
            }
            fetchExpectation?.fulfill()
        }
        waitForExpectations(timeout: 100, handler: nil)
    }
}
