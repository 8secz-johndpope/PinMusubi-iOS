//
//  SettingBasePointCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// 設定したい地点を入力するセル
public class SettingBasePointCell: UITableViewCell {
    // textField
    @IBOutlet private var pointNameTextField: UITextField!
    @IBOutlet private var addressTextField: UITextField!
    // textFieldの背景
    @IBOutlet private var pointNameView: UIView!
    @IBOutlet private var addressView: UIView!
    // 画像
    @IBOutlet private var pinImageOnModal: UIImageView!
    @IBOutlet private var addressStatusImage: UIImageView!
    @IBOutlet private var brokenLineImage: UIImageView!
    // 画像の背景
    @IBOutlet private var underWhiteView: UIView!
    @IBOutlet private var underView: UIView!

    /// 処理を地点設定Viewに委譲するDelegate
    public weak var delegate: SettingBasePointCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // delegateの設定
        pointNameTextField.delegate = self
        addressTextField.delegate = self
        // textFieldの設定
        pointNameTextField.borderStyle = .none
        pointNameTextField.placeholder = "例）太郎君の家"
        addressTextField.borderStyle = .none
        addressTextField.placeholder = "例) 東京都目黒区下目黒◯-◯, 東京駅"
        // textFieldの背景の設定
        pointNameView.layer.cornerRadius = 4
        addressView.layer.cornerRadius = 4
        // 画像の背景の設定
        underWhiteView.layer.cornerRadius = 17
        underView.layer.cornerRadius = 17
    }

    /// セル選択時の状態を変化させない
    /// - Parameter selected: 選択状態
    /// - Parameter animated: 選択時のアニメーション
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    /// セル削除時、セルの状態をリセット
    public func clearTextField() {
        pointNameTextField.text = ""
        addressTextField.text = ""
        addressStatusImage.image = nil
    }

    /// セルの行番号に合わせてピンのイメージカラーを変化
    /// - Parameter row: セルの行番号
    public func setPinImage(row: Int) {
        underView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let setImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImageOnModal.image = setImage
    }

    /// 点線を描写
    public func setBrokenLine() {
        guard let setImage = UIImage(named: "BrokenLine") else { return }
        brokenLineImage.image = setImage
    }

    /// 住所の入力チェック結果に応じて住所の入力チェック状態を変更
    /// - Parameter addressValidationStatus: 住所の入力チェック結果
    public func setAddressStatus(addressValidationStatus: AddressValidationStatus) {
        switch addressValidationStatus {
        case .empty:
            addressStatusImage.image = nil

        case .success:
            guard let image = UIImage(named: "SuccessStatus") else { return }
            addressStatusImage.image = image

        case .error:
            guard let image = UIImage(named: "ErrorStatus") else { return }
            addressStatusImage.image = image
        }
    }
}

/// textFieldに関するDelegateメソッド
extension SettingBasePointCell: UITextFieldDelegate {
    /// 編集開始した後
    /// - Parameter textField: 対象のtextField
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = delegate else { return }
        // セルを編集中セルに設定
        delegate.setEditingCell(editingCell: self)
        // アクションボタンを隠蔽
        delegate.hideActionButton()
    }

    /// フォーカスが外れた後
    /// - Parameter textField: 対象のtextField
    /// - Parameter reason: 編集終了結果
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == pointNameTextField {
            guard let pointName = textField.text else { return }
            guard let delegate = delegate else { return }
            delegate.setPointName(name: pointName)
        } else {
            guard let address = textField.text else { return }
            guard let delegate = delegate else { return }
            delegate.validateAddress(address: address)
        }
    }

    /// 改行される前
    /// - Parameter textField: 対象のtextField
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

/// 住所の入力チェック結果
public enum AddressValidationStatus {
    /// テキストが空
    case empty
    /// 成功
    case success
    /// 失敗
    case error
}
