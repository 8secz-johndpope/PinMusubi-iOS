//
//  SearchCriteriaModalViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCriteriaModalViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        // モーダルの中身を設定
        guard let modalContentView =
            UINib(nibName: "ModalContentView", bundle: Bundle.main)
                .instantiate(withOwner: self, options: nil)
                .first as? ModalContentView else { return }
        modalContentView.frame = view.frame
        view.addSubview(modalContentView)
    }
}
