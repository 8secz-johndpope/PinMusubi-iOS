//
//  SpotListCollectionViewCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/31.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// spotListを表示するCollectionCellのDelegate
public protocol SpotListCollectionViewCellDelegate: AnyObject {
    /// スポット詳細画面を表示
    func showSpotDetailsView(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol)
}
