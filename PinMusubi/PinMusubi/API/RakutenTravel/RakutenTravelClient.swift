//
//  RakutenTravelClient.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

class RakutenTravelClient {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()

    func send<Request: RakutenTravelRequest>(
        request: Request,
        completion: @escaping (APIResult<Request.Response, RakutenTravelClientError>) -> Void
    ) {
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) { data, response, error in
            switch (data, response, error) {
            case let (_, _, error?):
                completion(APIResult(error: .connectionError(error)))

            case let (data?, response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(APIResult(value: response))
                } catch let error as RakutenTravelAPIError {
                    completion(APIResult(error: .apiError(error)))
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
