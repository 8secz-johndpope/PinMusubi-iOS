//
//  TravelTimePanelViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import UIKit

class TravelTimePanelViewController: UIViewController {
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TravelTimePanelCell", bundle: nil), forCellReuseIdentifier: "TravelTimePanelCell")
        }
    }

    private var myData: MyDataEntityProtocol?
    private let cellSize = 135
    private var cellCount = 0

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        if let favoriteData = myData as? FavoriteSpotEntity {
            let settingPoints = favoriteData.settingPointEntityList
            cellCount = settingPoints.count
        }

        tableView.heightAnchor.constraint(equalToConstant: CGFloat(cellSize * cellCount)).isActive = true
    }

    public func setParameter(myData: MyDataEntityProtocol) {
        self.myData = myData
    }
}

extension TravelTimePanelViewController: UITableViewDelegate {}

extension TravelTimePanelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTimePanelCell") as? TravelTimePanelCell else { return TravelTimePanelCell() }
        if let favoriteData = myData as? FavoriteSpotEntity {
            let settingPoint = favoriteData.settingPointEntityList[indexPath.row]
            let favoriteSpot = CLLocationCoordinate2D(latitude: favoriteData.latitude, longitude: favoriteData.longitude)
            cell.configureContents(row: indexPath.row, settingPoint: settingPoint, spotPoint: favoriteSpot)
            cell.delegate = self
        }
        return cell
    }
}

extension TravelTimePanelViewController: TravelTimePanelCellDelegate {
    func showWebPage(webVCInstance: WebViewController) {
        present(webVCInstance, animated: true, completion: nil)
    }
}
