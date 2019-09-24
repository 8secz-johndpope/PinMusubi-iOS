//
//  PointInfoCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class PointInfoCell: UITableViewCell {
    @IBOutlet private var pointNameLabel: UILabel!
    @IBOutlet private var transferTimeLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    public func setPointInfo(pointName: String, transferTime: Int) {
        pointNameLabel.text = pointName
        let hour = transferTime / 60
        if hour == 0 {
            transferTimeLabel.text = String(transferTime) + "分"
        } else {
            transferTimeLabel.text = String(hour) + "時間" + String(transferTime % 60) + "分"
        }
    }
}
