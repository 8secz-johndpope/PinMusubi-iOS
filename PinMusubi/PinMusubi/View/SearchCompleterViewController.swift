//
//  SearchCompleterViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCompleterViewController: UIViewController {
    @IBOutlet private var addressTextField: UITextField! {
        didSet {
            addressTextField.delegate = self
            addressTextField.text = editingCell?.getAddress()
            addressTextField.becomeFirstResponder()
        }
    }

    private var editingCell: SettingBasePointCell?

    public func setInputEditingCellInstance(inputEditingCell: SettingBasePointCell) {
        editingCell = inputEditingCell
    }

    @IBAction private func didTappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchCompleterViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let outputAddress = addressTextField.text else { return true }
        editingCell?.setAddress(outputAddress: outputAddress)
        editingCell?.delegate?.validateAddress(address: outputAddress)
        dismiss(animated: true, completion: nil)
        return true
    }
}
