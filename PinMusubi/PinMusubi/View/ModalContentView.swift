//
//  ModalContentView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class ModalContentView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var searchCriteriaTableView: UITableView!
    private var cellRow: Int = 3

    override public func awakeFromNib() {
        super.awakeFromNib()

        // tableViewにcellを登録
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaCell")
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaActionCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaActionCell")
    }

    @IBAction private func didTapView(_ sender: Any) {
        self.endEditing(true)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRow + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellRow != indexPath.row {
            // 検索条件セルの設定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCriteriaCell") as? SearchCriteriaCell else { return UITableViewCell() }
            cell.setPinOnModal(row: indexPath.row % 10)
            return cell
        } else {
            // アクションセルの設定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCriteriaActionCell") as? SearchCriteriaActionCell else { return UITableViewCell() }
            if cellRow == 2 {
                cell.hideRemoveButton()
            } else {
                cell.appearRemoveButton()
            }
            return cell
        }
    }
}
