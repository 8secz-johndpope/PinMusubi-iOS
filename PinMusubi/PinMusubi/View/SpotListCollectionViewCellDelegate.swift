//
//  SpotListCollectionViewCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/31.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds

/// spotListを表示するCollectionCellのDelegate
protocol SpotListCollectionViewCellDelegate: AnyObject {
    /// スポット詳細画面を表示
    func showSpotDetailsView(settingPoints: [SettingPointEntity], spot: SpotEntity)
    /// スポットの数を設定
    func setNumOfSpot(num: Int, spotType: SpotType)
    /// スポットタップ時のスポットタイプを設定
    func setSpotTypeOfTappedSpot(spotType: SpotType)

    func setRootVC(bannerView: GADBannerView)
}
