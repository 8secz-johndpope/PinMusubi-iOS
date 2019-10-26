//
//  KeyManager.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/26.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

/// APIKeyを管理するクラス
public struct KeyManager {
    private let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")

    /// plistからKeyを取得
    public func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }

    /// keyからAPIKeyを取得
    /// - Parameter key: plistのkey
    public func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        guard let value = keys[key] else { return  nil }
        return value as AnyObject
    }
}
