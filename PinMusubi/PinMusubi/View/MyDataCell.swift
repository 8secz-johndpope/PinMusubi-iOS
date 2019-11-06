//
//  MyDataCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Cosmos
import UIKit

public class MyDataCell: UITableViewCell {
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!
    @IBOutlet private var registerDate: UILabel!
    @IBOutlet private var ratingView: CosmosView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.totalStars = 5
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
