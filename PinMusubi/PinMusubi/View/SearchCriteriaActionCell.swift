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
    @IBOutlet private var removeCellButtonView: UIView!
    @IBOutlet private var doneSettingButtonView: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // ActionButtonの設定
        addCellButtonView.layer.cornerRadius = 20
        addCellButtonView.layer.borderWidth = 0.5
        addCellButtonView.layer.borderColor = UIColor.lightGray.cgColor
        removeCellButtonView.layer.cornerRadius = 20
        removeCellButtonView.layer.borderWidth = 0.5
        removeCellButtonView.layer.borderColor = UIColor.lightGray.cgColor
        doneSettingButtonView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
        doneSettingButtonView.layer.cornerRadius = 8
    }

    public func hideRemoveButton() {
        removeCellButtonView.isHidden = true
    }

    public func appearRemoveButton() {
        removeCellButtonView.isHidden = false
    }
}
