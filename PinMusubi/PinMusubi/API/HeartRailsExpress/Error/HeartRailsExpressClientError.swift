//
//  HeartRailsExpressClientError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/23.
//  Copyright © 2020 naipaka. All rights reserved.
//

enum HeartRailsExpressClientError: Error {
    // 通信に失敗
    case connectionError(Error)

    // レスポンスの解釈に失敗
    case responseParseError(Error)
}
