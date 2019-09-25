//
//  SearchCriteriaCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCriteriaCell: UITableViewCell {
    // textFieldの背景
    @IBOutlet private var pointNameView: UIView!
    @IBOutlet private var addressView: UIView!
    // 画像の背景
    @IBOutlet private var underWhiteView: UIView!
    @IBOutlet private var underView: UIView!
    // textField
    @IBOutlet private var pointNameTextField: UITextField!
    @IBOutlet private var addressTextField: UITextField!
    // 画像
    @IBOutlet private var pinImageOnModal: UIImageView!
    @IBOutlet private var addressStatusImage: UIImageView!
    @IBOutlet private var brokenLineImage: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // textFieldの背景の設定
        pointNameView.layer.cornerRadius = 4
        addressView.layer.cornerRadius = 4
        // 画像の背景の設定
        underWhiteView.layer.cornerRadius = 17
        underView.layer.cornerRadius = 17
        // textFieldの設定
        pointNameTextField.borderStyle = .none
        pointNameTextField.placeholder = "例）自分の家"
        addressTextField.borderStyle = .none
        addressTextField.placeholder = "例) 東京都目黒区下目黒◯-◯"
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    public func getTextFields() -> (UITextField, UITextField) {
        return (pointNameTextField, addressTextField)
    }

    public func setPinOnModal(row: Int) {
        underView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let setImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImageOnModal.image = setImage
    }

    public func setBrokenLine() {
        guard let setImage = UIImage(named: "BrokenLine") else { return }
        brokenLineImage.image = setImage
    }

    public func checkRequired() -> Bool {
        if pointNameTextField.text == "" {
            return false
        }
        if addressTextField.text == "" {
            return false
        }
        return true
    }

    public func checkAddress() -> Bool {
        if addressTextField.text == "" {
            return false
        }
        return true
    }

    public func setAddressStatus(inputStatus: String) {
        switch inputStatus {
        case "empty":
            addressStatusImage.image = nil
        case "success":
            guard let image = UIImage(named: "SuccessStatus") else { return }
            addressStatusImage.image = image
        case "error":
            guard let image = UIImage(named: "ErrorStatus") else { return }
            addressStatusImage.image = image

        default:
            addressStatusImage.image = nil
        }
    }
}