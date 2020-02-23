//
//  HotpepperError.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperError
struct HotpepperError: Decodable {
    let message: String
    let code: HotpepperErrorCode

    enum HotpepperErrorCode: Int, Decodable {
        case serverError = 1_000             // サーバ障害エラー
        case authenticationError = 2_000     // APIキーまたはIPアドレスの認証エラー
        case parameterError = 3_000          // パラメータ不正エラー
    }
}
