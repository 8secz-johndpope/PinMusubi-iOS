//
//  SearchCriteriaModalViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SearchCriteriaModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var searchCriteriaTableView = UITableView()
    private var cellRow: Int = 3

    override public func viewDidLoad() {
        super.viewDidLoad()

        // モーダルの中身を設定
        guard let modalContentView =
            UINib(nibName: "ModalContentView", bundle: Bundle.main)
                .instantiate(withOwner: self, options: nil)
                .first as? ModalContentView else { return }
        modalContentView.frame = view.frame
        view.addSubview(modalContentView)

        // tableViewにSearchCriteriaCellを登録
        searchCriteriaTableView = modalContentView.getTableView()
        searchCriteriaTableView.delegate = self
        searchCriteriaTableView.dataSource = self
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaCell")
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaActionCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaActionCell")
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
            return cell
        }
    }
}
