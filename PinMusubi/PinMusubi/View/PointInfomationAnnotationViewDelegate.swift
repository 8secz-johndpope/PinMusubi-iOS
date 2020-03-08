//
//  PointInfomationAnnotationViewDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

protocol PointInfomationAnnotationViewDelegate: AnyObject {
    func searchSpotList()

    func showShareActivity(activityVC: UIActivityViewController)

    func showTransportationGuideWebPage(webVCInstance: WebViewController)
}
