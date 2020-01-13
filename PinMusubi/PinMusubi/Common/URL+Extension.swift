//
//  URL+Extension.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

public extension URL {
    /// 指定したURLクエリパラメーターの値を取得する
    /// - Parameter key: URLクエリパラメーターのキー
    /// - Returns: 指定したURLクエリパラメーターの値（存在しない場合はnil）
    func queryValue(for key: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        return queryItems?.filter { $0.name == key }.compactMap { $0.value }.first
    }
}
