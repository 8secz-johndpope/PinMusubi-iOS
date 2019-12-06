//
//  MyDetailsDataActionViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class MyDetailsDataActionViewController: UIViewController {
    @IBOutlet private var moveMapButton: UIButton! {
        didSet {
            moveMapButton.layer.borderWidth = 2.0
            moveMapButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            moveMapButton.layer.cornerRadius = 10
            moveMapButton.layer.shadowOpacity = 0.5
            moveMapButton.layer.shadowRadius = 3
            moveMapButton.layer.shadowColor = UIColor.gray.cgColor
            moveMapButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }

    @IBOutlet private var moveSpotListButton: UIButton! {
        didSet {
            moveSpotListButton.layer.borderWidth = 2.0
            moveSpotListButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            moveSpotListButton.layer.cornerRadius = 10
            moveSpotListButton.layer.shadowOpacity = 0.5
            moveSpotListButton.layer.shadowRadius = 3
            moveSpotListButton.layer.shadowColor = UIColor.gray.cgColor
            moveSpotListButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }

    public weak var delegate: MyDetailsDataActionViewDelegate?

    @IBAction private func didTapMoveMapButton(_ sender: Any) {
        delegate?.moveFromMyPage(viewType: .map)
    }

    @IBAction private func didTapMoveSpotListButton(_ sender: Any) {
        delegate?.moveFromMyPage(viewType: .spotList)
    }
}
