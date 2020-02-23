//
//  EkispertClient.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

class EkispertClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    func send<Request: EkispertRequest>(
        request: Request,
        completion: @escaping (APIResult<(Request.Response?, Request.Response2?), EkispertClientError>) -> Void
    ) {
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case let (_, _, error?):
                completion(APIResult(error: .connectionError(error)))

            case let (data?, response?, _):
                do {
                    let (response, response2) = try request.response(from: data, urlResponse: response)
                    completion(APIResult(value: (response, response2)))
                } catch {
                    completion(APIResult(error: .responseParseError(error)))
                }

            default:
                fatalError("invalid response combination \(String(describing: data)), \(String(describing: response)), \(String(describing: error)).")
            }
        }

        task.resume()
    }
}
