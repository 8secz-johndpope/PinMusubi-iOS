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
    private var editingTextFieldView = UIView()
    // ピン画像
    @IBOutlet private var pinImageOnModal: UIImageView!
    // 親view
    public weak var delegate: SearchCriteriaCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // delegateの設定
        pointNameTextField.delegate = self
        addressTextField.delegate = self
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
        // textFieldに関する通知を設定
        registerNotification()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    public func setPinOnModal(row: Int) {
        underView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let setImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImageOnModal.image = setImage
    }
}

extension SearchCriteriaCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let superView = textField.superview else { return }
        editingTextFieldView = superView
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pointNameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        return false
    }
}

public extension SearchCriteriaCell {
    /// 通知登録
    func registerNotification() {
        // 通知センターの取得
        let notification = NotificationCenter.default
        // キーボード登場通知の設定
        notification.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // キーボードの退出通知の設定
        notification.addObserver(
            self,
            selector: #selector(self.didHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// キーボード登場時にtextFieldの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func willShowKeyboard(_ notification: Notification) {
//        delegate?.scrollUpWithKeyboard(textFieldLimit: <#T##CGFloat#>, keyboardFieldLimit: <#T##CGFloat#>)
        print("😄")
    }

    /// キーボード退出時にtextFieldの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func didHideKeyboard(_ notification: Notification) {
    }
}
