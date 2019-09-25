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
    private var isEnabledDoneSetting = false

    public weak var delegate: SearchCriteriaActionDelegate?

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
        addCellView.addGestureRecognizer(tapAddCellViewGesture)
        let tapRemoveCellViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedRemoveCellView(_:)))
        removeCellView.addGestureRecognizer(tapRemoveCellViewGesture)
        let tapDoneSettingView = UITapGestureRecognizer(target: self, action: #selector(self.tappedDoneSettingView(_:)))
        doneSettingView.addGestureRecognizer(tapDoneSettingView)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    public func hideRemoveButton() {
        removeCellView.isHidden = true
    }

    public func appearRemoveButton() {
        removeCellView.isHidden = false
    }

    public func changeDoneSettingStatus(canDoneSetting: Bool) {
        if canDoneSetting {
            doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 1)
            isEnabledDoneSetting = true
        } else {
            doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
            isEnabledDoneSetting = false
        }
    }

    @IBAction private func tappedAddCellView(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        delegate.addSearchCriteriaCell()
    }

    @IBAction private func tappedRemoveCellView(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        delegate.removeSearchCriteriaCell()
    }

    @IBAction private func tappedDoneSettingView(_ sender: UITapGestureRecognizer) {
        if isEnabledDoneSetting {
            NotificationCenter.default.post(name: Notification.doneSettingNotification, object: nil)
            guard let delegate = delegate else { return }
            delegate.doneSetting()
        }
    }
}