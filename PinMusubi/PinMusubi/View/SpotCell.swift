//
//  SpotCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotCell: UITableViewCell {
    @IBOutlet private var catchImage: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        title.text = "タイトルテスト"
        subTitle.text = "サブタイトルテスト"
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func transportationConfigure() {
    }

    public func restaurantConfigure() {
    }
}
