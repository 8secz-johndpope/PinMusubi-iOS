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
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの内容を取得
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCriteriaCell") as? SearchCriteriaCell else { return UITableViewCell() }
        cell.setPinOnModal(row: indexPath.row % 10)
        return cell
    }
}
