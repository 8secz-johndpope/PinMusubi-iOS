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
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            guard let favoriteData = favoriteData else { return }
            titleLabel.text = favoriteData.title
        }
    }

    @IBOutlet private var memoLabel: UILabel! {
        didSet {
            guard let favoriteData = favoriteData else { return }
            memoLabel.text = favoriteData.memo
            memoLabel.numberOfLines = 0
            memoLabel.sizeToFit()
        }
    }

    @IBOutlet private var ratingView: CosmosView! {
        didSet {
            guard let favoriteData = favoriteData else { return }
            ratingView.rating = favoriteData.rating
            ratingView.isUserInteractionEnabled = false
        }
    }

    private var favoriteData: FavoriteSpotEntity?

    public func getFavoriteData(id: String) {
        let model = MyDataModel()
        favoriteData = model.fetchFavoriteData(id: id)
    }
}
