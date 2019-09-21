//
//  ModalContentView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class ModalContentView: UIView {
    @IBOutlet private var searchCriteriaTableView: UITableView!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func getTableView() -> UITableView {
        return searchCriteriaTableView
    }

    @IBAction private func didTapView(_ sender: Any) {
        self.endEditing(true)
    }
}
