//
//  PointInfoView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class PointInfoView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var pointInfoTableView: UITableView!
    @IBOutlet private var showSpotListView: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        showSpotListView.backgroundColor = UIColor(hex: "FA6400")
        showSpotListView.layer.cornerRadius = 8

        pointInfoTableView.register(UINib(nibName: "PointInfoCell", bundle: nil), forCellReuseIdentifier: "PointInfoCell")

        pointInfoTableView.delegate = self
        pointInfoTableView.dataSource = self
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfoCell") as? PointInfoCell else { return UITableViewCell() }
        cell.setPointInfo(pointName: "わいの家", transferTime: 10)
        return cell
    }
}
