//
//  SearchCriteriaActionCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCriteriaActionCell: UITableViewCell {
    @IBOutlet private var addCellButtonView: UIView!
    @IBOutlet private var doneSettingButtonView: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Buttonの設定
        addCellButtonView.layer.cornerRadius = 20
        addCellButtonView.layer.borderWidth = 0.5
        addCellButtonView.layer.borderColor = UIColor.lightGray.cgColor
        doneSettingButtonView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
        doneSettingButtonView.layer.cornerRadius = 8
    }
}
