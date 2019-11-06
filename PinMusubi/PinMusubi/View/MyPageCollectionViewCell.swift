//
//  MyPageCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class MyPageCollectionViewCell: UICollectionViewCell {
    private var scrollView: UIScrollView?
    private var tableView: UITableView?
    private var myPageList = [MyDataEntityProtocol]()

    public func configre() {
        configrationContent()
    }

    private func configrationContent() {
        scrollView = UIScrollView(frame: bounds)
        guard let scrollView = scrollView else { return }
        addSubview(scrollView)

        tableView = UITableView(frame: bounds, style: .plain)
        guard let tableView = tableView else { return }
        tableView.tableFooterView = UIView(frame: .zero)
        scrollView.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UINib(nibName: "MyDataCell", bundle: nil), forCellReuseIdentifier: "MyDataCell")
    }
}

extension MyPageCollectionViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.5
    }
}

extension MyPageCollectionViewCell: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return myPageList.count
        return 10
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyDataCell", for: indexPath) as? MyDataCell else { return MyDataCell() }
        cell.selectionStyle = .none
        return cell
    }
}
