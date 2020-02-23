//
//  APIResult.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/22.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum APIResult<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)

    init(value: T) {
        self = .success(value)
    }

    init(error: Error) {
        self = .failure(error)
    }
}
