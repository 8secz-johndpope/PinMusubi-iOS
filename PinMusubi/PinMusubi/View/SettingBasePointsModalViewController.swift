//
//  SettingBasePointsModalViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// モーダルのViewController
public class SettingBasePointsModalViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        // モーダルの中身のViewを設定
        guard let modalContentView = UINib(nibName: "SettingBasePointsView", bundle: Bundle.main)
            .instantiate(withOwner: self, options: nil)
            .first as? SettingBasePointsView else { return }
        modalContentView.frame = view.frame
        view.addSubview(modalContentView)
    }
}
