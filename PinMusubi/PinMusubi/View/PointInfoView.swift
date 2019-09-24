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
    private var cellRow = 0
    private var pointNames = [String]()
    private var transferTimes = [Int]()

    override public func awakeFromNib() {
        super.awakeFromNib()
        showSpotListView.backgroundColor = UIColor(hex: "FA6400")
        showSpotListView.layer.cornerRadius = 8

        pointInfoTableView.register(UINib(nibName: "PointInfoCell", bundle: nil), forCellReuseIdentifier: "PointInfoCell")

        pointInfoTableView.delegate = self
        pointInfoTableView.dataSource = self
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRow
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfoCell") as? PointInfoCell else { return UITableViewCell() }
        cell.setPointInfo(pointName: pointNames[indexPath.row], transferTime: transferTimes[indexPath.row])
        return cell
    }

    public func setPointInfo(settingPoints: [SettingPointEntity], transferTimes: [Int]) {
        for count in 0...settingPoints.count - 1 {
            pointNames.append(settingPoints[count].name)
            self.transferTimes.append(transferTimes[count])
            cellRow += 1
        }
        pointInfoTableView.reloadData()
    }
}
