//
//  MyPageCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// 個人データの種類
public enum MyDataType {
    /// お気に入り
    case favorite
    /// 検索履歴
    case history
}

public class MyPageCollectionViewCell: UICollectionViewCell {
    private var scrollView: UIScrollView?
    private var tableView: UITableView?
    private var myDataType: MyDataType?
    private var myDataList = [MyDataEntityProtocol]()
    private var presenter: MyDataPresenterProtocol?

    public weak var delegate: MyPageCollectionViewCellDelegate?

    public func configre(myDataType: MyDataType) {
        self.myDataType = myDataType
        self.presenter = MyDataPresenter(view: self, modelType: MyDataModel.self)
        configrationContent()
        getMyDataList(myDataType: myDataType)
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

        if #available(iOS 13.0, *) {
            scrollView.backgroundColor = .secondarySystemBackground
            tableView.backgroundColor = .secondarySystemBackground
        }
    }

    private func getMyDataList(myDataType: MyDataType) {
        guard let presenter = presenter else { return }
        if myDataType == .favorite {
            self.myDataList = presenter.getFavoriteDataList(orderType: .descendingByCreateDate)
        } else if myDataType == .history {
            self.myDataList = presenter.getHistoryDataList(orderType: .descendingByCreateDate)
        }
        tableView?.reloadData()

        if myDataList.isEmpty {
            setEmptyView(myDataType: myDataType)
        }
    }

    private func setEmptyView(myDataType: MyDataType) {
        guard let emptyView = UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: self, options: nil).first as? EmptyView else { return }
        if myDataType == .favorite {
            emptyView.setEmptyType(emptyType: .favorite)
        } else if myDataType == .history {
            emptyView.setEmptyType(emptyType: .history)
        }
        emptyView.frame = bounds
        tableView?.addSubview(emptyView)
    }
}

extension MyPageCollectionViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.showSpotDetailsView(myData: myDataList[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

extension MyPageCollectionViewCell: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyDataCell", for: indexPath) as? MyDataCell else { return MyDataCell() }
        cell.selectionStyle = .none
        cell.configure(myDataType: myDataList[indexPath.row])
        return cell
    }
}
