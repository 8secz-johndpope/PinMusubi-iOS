//
//  SpotDetailsViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/31.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotDetailsViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public func configure(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol) {
        if spot is Shop {
            guard let restaurant = spot as? Shop else { return }
            title = restaurant.name
        } else if spot is Station {
            guard let station = spot as? Station else { return }
            title = station.name
        } else if spot is BusStopEntity {
            guard let busStop = spot as? BusStopEntity else { return }
            title = busStop.busStopName
        }
    }

    @IBAction private func backNavigationView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
