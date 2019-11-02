//
//  SpotBaseInfoView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotBaseInfoView: UIView {
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var fromTrainLabel: UILabel!
    @IBOutlet private var businessTimeLabel: UILabel!
    @IBOutlet private var regularHolidayLabel: UILabel!
    @IBOutlet private var seatCountLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configureLabel(shop: Shop) {
        addressLabel.text = shop.address
        fromTrainLabel.text = shop.access
        businessTimeLabel.text = shop.open
        regularHolidayLabel.text = shop.close
        seatCountLabel.text = shop.capacity
    }
}
