//
//  SettingBasePointsViewAdDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/03.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds
import MapKit

/// 広告に関するDelegate
public protocol SettingBasePointsViewAdDelegate: AnyObject {
    /// rootViewControllerの設定
    /// - Parameter bannerView: バナー広告View
    func setRootVC(bannerView: GADBannerView)
}
