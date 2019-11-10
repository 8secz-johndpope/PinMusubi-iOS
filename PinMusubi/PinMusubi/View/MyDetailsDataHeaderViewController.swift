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

    private var favoriteData: FavoriteSpotEntity?

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public func getFavoriteData(id: String) {
        let model = MyDataModel()
        favoriteData = model.fetchFavoriteData(id: id)
    }

    private func configureUI() {
        guard let favoriteData = favoriteData else { return }
        titleLabel.text = favoriteData.title
        memoLabel.text = favoriteData.memo
        memoLabel.numberOfLines = 0
        memoLabel.sizeToFit()
        ratingView.rating = favoriteData.rating
        ratingView.isUserInteractionEnabled = false
    }
}
