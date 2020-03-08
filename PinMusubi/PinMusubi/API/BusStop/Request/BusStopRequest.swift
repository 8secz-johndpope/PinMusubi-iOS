//
//  BusStopRequest.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

protocol BusStopRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension BusStopRequest {
    var baseURL: URL {
        return URL(string: "https://livlog.xyz/busstop")!
    }

    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        switch method {
        case .get:
            components?.queryItems = queryItems

        default:
            fatalError("Unsupported method \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }

    func response(from data: Data, urlResponse: URLResponse) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
