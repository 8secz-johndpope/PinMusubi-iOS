//
//  SpotWebInfomationView.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

class SpotWebInfomationView: UIView {
    @IBOutlet private var moveWebViewButton: UIButton! {
        didSet {
            moveWebViewButton.setTitle("詳細を見る・予約する", for: .normal)
            moveWebViewButton.setTitleColor(UIColor.white, for: .normal)
            moveWebViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            moveWebViewButton.layer.cornerRadius = 10
            moveWebViewButton.backgroundColor = UIColor(hex: "FA6400")

            moveWebViewButton.layer.shadowOpacity = 0.5
            moveWebViewButton.layer.shadowRadius = 3
            moveWebViewButton.layer.shadowColor = UIColor.gray.cgColor
            moveWebViewButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }

    weak var delegate: SpotDetailViewDelegate?

    @IBAction private func didTapMoveWebViewButton(_ sender: Any) {
        delegate?.presentWebView()
    }
}
