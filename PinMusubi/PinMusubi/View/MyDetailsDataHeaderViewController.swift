//
//  MyDetailsDataHeaderViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Cosmos
import UIKit

public class MyDetailsDataHeaderViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var memoLabel: UILabel!
    @IBOutlet private var ratingView: CosmosView!

    private var myData: MyDataEntityProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public func setParameter(myData: MyDataEntityProtocol) {
        self.myData = myData
    }

    private func configureUI() {
        if let favoriteData = myData as? FavoriteSpotEntity {
            titleLabel.text = favoriteData.title
            memoLabel.text = favoriteData.memo
            memoLabel.numberOfLines = 0
            memoLabel.sizeToFit()
            ratingView.rating = favoriteData.rating
            ratingView.isUserInteractionEnabled = false
        }
    }
}
