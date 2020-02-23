//
//  EkispertRequest.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

protocol EkispertRequest {
    associatedtype Response: Decodable
    associatedtype Response2: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension EkispertRequest {
    var baseURL: URL {
        return URL(string: "http://api.ekispert.jp")!
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

    func response(from data: Data, urlResponse: URLResponse) throws -> (Response?, Response2?) {
        var response: Response?
        var response2: Response2?

        do {
            response = try JSONDecoder().decode(Response.self, from: data)
        } catch {
            response2 = try JSONDecoder().decode(Response2.self, from: data)
        }

        return (response, response2)
    }
}
