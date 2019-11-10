//
//  MyDetailsDataActionViewDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// 遷移先のViewのType
public enum ViewType {
    /// マップ
    case map
    /// スポット一覧
    case spotList
}

/// ActionViewDelegate
public protocol MyDetailsDataActionViewDelegate: AnyObject {
    /// マイページからの遷移
    func moveFromMyPage(viewType: ViewType)
}
