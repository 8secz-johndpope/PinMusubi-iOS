//
//  MKLocalSearchClient.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import MapKit

enum MKLocalSearchClient {
    static func search(request: MKLocalSearch.Request, completionHandler: @escaping (APIResult<[MKMapItem], Error>) -> Void) {
        MKLocalSearch(request: request).start { response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(response?.mapItems ?? []))
        }
    }
}
