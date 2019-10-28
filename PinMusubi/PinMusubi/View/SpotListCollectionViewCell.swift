//
//  SpotListCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// スポットの形式
public enum SpotType {
    /// 交通機関
    case transportation
    /// 飲食店
    case restaurant
}

public class SpotListCollectionViewCell: UICollectionViewCell {
    private var spotListScrollView: UIScrollView?
    private var spotListTableView: UITableView?
    private var spotType: SpotType?

    public func configre(spotType: SpotType, collectionViewSize: CGSize) {
        self.spotType = spotType
        sizeThatFits(collectionViewSize)
        spotListScrollView = UIScrollView(frame: bounds)
        guard let spotListScrollView = spotListScrollView else { return }
        addSubview(spotListScrollView)
        spotListTableView = UITableView(frame: bounds, style: .plain)
        guard let spotListTableView = spotListTableView else { return }
        spotListScrollView.addSubview(spotListTableView)

        spotListTableView.delegate = self
        spotListTableView.dataSource = self

        spotListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension SpotListCollectionViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension SpotListCollectionViewCell: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if spotType == .transportation {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        } else if spotType == .restaurant {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
}
