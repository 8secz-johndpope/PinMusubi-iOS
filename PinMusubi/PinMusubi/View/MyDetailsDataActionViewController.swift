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
        }
    }

    @IBOutlet private var moveSpotListButton: UIButton! {
        didSet {
            moveSpotListButton.layer.borderWidth = 2.0
            moveSpotListButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            moveSpotListButton.layer.cornerRadius = 10
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
