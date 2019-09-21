//
//  SearchCriteriaActionCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCriteriaActionCell: UITableViewCell {
    @IBOutlet private var addCellView: UIView!
    @IBOutlet private var removeCellView: UIView!
    @IBOutlet private var doneSettingView: UIView!
    private var parentVC = SearchCriteriaModalViewController()

    override public func awakeFromNib() {
        super.awakeFromNib()
        // ActionButtonの設定
        addCellView.layer.cornerRadius = 20
        addCellView.layer.borderWidth = 0.5
        addCellView.layer.borderColor = UIColor.lightGray.cgColor
        removeCellView.layer.cornerRadius = 20
        removeCellView.layer.borderWidth = 0.5
        removeCellView.layer.borderColor = UIColor.lightGray.cgColor
        doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
        doneSettingView.layer.cornerRadius = 8

        // gestureの設定
        let tapAddCellViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddCellView(_:)))
        tapAddCellViewGesture.delegate = self
        addCellView.addGestureRecognizer(tapAddCellViewGesture)
        let tapRemoveCellViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedRemoveCellView(_:)))
        tapRemoveCellViewGesture.delegate = self
        removeCellView.addGestureRecognizer(tapRemoveCellViewGesture)
        let tapDoneSettingView = UITapGestureRecognizer(target: self, action: #selector(self.tappedDoneSettingView(_:)))
        tapDoneSettingView.delegate = self
        doneSettingView.addGestureRecognizer(tapDoneSettingView)
    }

    public func hideRemoveButton() {
        removeCellView.isHidden = true
    }

    public func appearRemoveButton() {
        removeCellView.isHidden = false
    }

    @IBAction private func tappedAddCellView(_ sender: UITapGestureRecognizer) {
        print("tappedAddCellView")
    }

    @IBAction private func tappedRemoveCellView(_ sender: UITapGestureRecognizer) {
        print("tappedRemoveCellView")
    }

    @IBAction private func tappedDoneSettingView(_ sender: UITapGestureRecognizer) {
        print("tappedDoneSettingView")
    }
}
