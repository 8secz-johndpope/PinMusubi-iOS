//
//  SpotListViewDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// 興味のある場所を探すViewのDelegate
public protocol SpotListViewDelegate: AnyObject {
    /// スポット一覧画面を閉じる
    func closeSpotListView()
}
