//
//  SearchCriteriaActionCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds
import UIKit

/// 地点設定に関するアクションを行うCell
public class SettingBasePointActionCell: UITableViewCell {
    @IBOutlet private var addCellView: UIView! {
        didSet {
            addCellView.layer.cornerRadius = 20
            addCellView.layer.borderWidth = 0.5
            addCellView.layer.borderColor = UIColor.lightGray.cgColor
            addCellView.isHidden = false
        }
    }

    @IBOutlet private var removeCellView: UIView! {
        didSet {
            removeCellView.layer.cornerRadius = 20
            removeCellView.layer.borderWidth = 0.5
            removeCellView.layer.borderColor = UIColor.lightGray.cgColor
            removeCellView.isHidden = true
        }
    }

    @IBOutlet private var doneSettingView: UIView! {
        didSet {
            doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
            doneSettingView.layer.cornerRadius = 8
        }
    }

    @IBOutlet private var adSuperView: UIView!

    private var isEnabledDoneSetting = false

    public weak var delegate: SettingBasePointActionCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()

        // gestureの設定
        let tapAddCellViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddCellView(_:)))
        addCellView.addGestureRecognizer(tapAddCellViewGesture)
        let tapRemoveCellViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedRemoveCellView(_:)))
        removeCellView.addGestureRecognizer(tapRemoveCellViewGesture)
        let tapDoneSettingView = UITapGestureRecognizer(target: self, action: #selector(self.tappedDoneSettingView(_:)))
        doneSettingView.addGestureRecognizer(tapDoneSettingView)
    }

    public func setAdBannerView(adBannerView: GADBannerView) {
        adSuperView.addSubview(adBannerView)
    }

    /// セル選択時の状態を変化させない
    /// - Parameter selected: 選択状態
    /// - Parameter animated: 選択時のアニメーション
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    /// アクションボタンを隠蔽
    public func hideActionButton() {
        doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
        addCellView.isHidden = true
        removeCellView.isHidden = true
        isEnabledDoneSetting = false
    }

    /// アクションボタンの状態の設定
    /// - Parameter maxRow: 現在の最大行数
    public func setButtonStatus(maxRow: Int) {
        if maxRow == 2 {
            addCellView.isHidden = false
            removeCellView.isHidden = true
        } else if maxRow == 10 {
            addCellView.isHidden = true
            removeCellView.isHidden = false
        } else {
            addCellView.isHidden = false
            removeCellView.isHidden = false
        }
    }

    /// 設定完了可否を変更
    /// - Parameter canDoneSetting: 全てのセルのチェック結果
    public func changeDoneSettingStatus(canDoneSetting: Bool) {
        if canDoneSetting {
            doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 1)
            isEnabledDoneSetting = true
        } else {
            doneSettingView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
            isEnabledDoneSetting = false
        }
    }

    /// 追加ボタン押下時
    /// - Parameter sender: UITapGestureRecognizer
    @IBAction private func tappedAddCellView(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        delegate.addSettingBasePointCell()
    }

    /// 削除ボタン押下時
    /// - Parameter sender: UITapGestureRecognizer
    @IBAction private func tappedRemoveCellView(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        delegate.removeSettingBasePointCell()
    }

    /// 設定完了ボタン押下時
    /// - Parameter sender: UITapGestureRecognizer
    @IBAction private func tappedDoneSettingView(_ sender: UITapGestureRecognizer) {
        if isEnabledDoneSetting {
            // 設定完了ボタン押下をMap画面に通知してモーダルを下げる
            NotificationCenter.default.post(name: Notification.doneSettingNotification, object: nil)
            guard let delegate = delegate else { return }
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            delegate.doneSetting()
        }
    }
}
