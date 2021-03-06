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
    @IBOutlet private var addressTextField: UITextField! {
        didSet {
            addressTextField.delegate = self
            addressTextField.borderStyle = .none
            addressTextField.placeholder = "例) 東京都目黒区下目黒◯-◯, 東京駅"
        }
    }

    @IBOutlet private var addressView: UIView! {
        didSet {
            addressView.layer.cornerRadius = 4
        }
    }

    @IBOutlet private var underWhiteView: UIView! {
        didSet {
            underWhiteView.layer.cornerRadius = 17
        }
    }

    @IBOutlet private var underView: UIView! {
        didSet {
            underView.layer.cornerRadius = 17
        }
    }

    @IBOutlet private var pinImageOnModal: UIImageView!
    @IBOutlet private var addressStatusImage: UIImageView!
    @IBOutlet private var brokenLineImage: UIImageView!

    public weak var delegate: SettingBasePointCellDelegate?

    /// セル選択時の状態を変化させない
    /// - Parameter selected: 選択状態
    /// - Parameter animated: 選択時のアニメーション
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    /// セル削除時、セルの状態をリセット
    public func clearTextField() {
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

    public func getAddress() -> String {
        return addressTextField.text ?? ""
    }

    public func setAddress(outputAddress: String) {
        addressTextField.text = outputAddress
    }
}

/// textFieldに関するDelegateメソッド
extension SettingBasePointCell: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            endEditing(true)
            delegate?.sendEditingCellInstance(inputEditingCell: self)
            return false
        }
        return true
    }

    /// 編集開始した後
    /// - Parameter textField: 対象のtextField
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // セルを編集中セルに設定
        delegate?.setEditingCell(editingCell: self)
        // アクションボタンを隠蔽
        delegate?.hideActionButton()
    }

    /// フォーカスが外れた後
    /// - Parameter textField: 対象のtextField
    /// - Parameter reason: 編集終了結果
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let pointName = textField.text else { return }
        guard let delegate = delegate else { return }
        delegate.setPointName(name: pointName)
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
