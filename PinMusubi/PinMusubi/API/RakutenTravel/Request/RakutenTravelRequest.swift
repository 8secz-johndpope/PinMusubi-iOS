//
//  RakutenTravelRequest.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation

protocol RakutenTravelRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension RakutenTravelRequest {
    var baseURL: URL {
        return URL(string: "https://app.rakuten.co.jp")!
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
        let decoder = JSONDecoder()

        if case (200..<300)? = (urlResponse as? HTTPURLResponse)?.statusCode {
            // JSONからモデルをインスタンス化
            return try decoder.decode(Response.self, from: data)
        } else {
            // JSONからAPIエラーをインスタンス化
            throw try decoder.decode(RakutenTravelAPIError.self, from: data)
        }
    }
}
