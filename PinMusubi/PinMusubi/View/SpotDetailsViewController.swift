//
//  SpotDetailsViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/31.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import SDWebImage
import UIKit

public class SpotDetailsViewController: UIViewController {
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var shopNameLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var showWebPageView: UIView!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var fromTrainLabel: UILabel!
    @IBOutlet private var businessTimeLabel: UILabel!
    @IBOutlet private var regularHolidayLabel: UILabel!
    @IBOutlet private var seatCountLabel: UILabel!
    @IBOutlet private var travelTimePanelTableView: UITableView!

    private var settingPoints: [SettingPointEntity]?
    private var spot: SpotEntityProtocol?
    private var spotPoint = CLLocationCoordinate2D()

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureContents()

        travelTimePanelTableView.delegate = self
        travelTimePanelTableView.dataSource = self
        travelTimePanelTableView.register(UINib(nibName: "TravelTimePanelCell", bundle: nil), forCellReuseIdentifier: "TravelTimePanelCell")
    }

    public func setParameter(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol) {
        self.settingPoints = settingPoints
        self.spot = spot
        if spot is Shop {
            guard let restaurant = spot as? Shop else { return }
            guard let lat = CLLocationDegrees(restaurant.lat) else { return }
            guard let lng = CLLocationDegrees(restaurant.lng) else { return }
            spotPoint.latitude = lat
            spotPoint.longitude = lng
        } else if spot is Station {
            guard let station = spot as? Station else { return }
            spotPoint.latitude = station.lat
            spotPoint.longitude = station.lng
        } else if spot is BusStopEntity {
            guard let busStop = spot as? BusStopEntity else { return }
            spotPoint.longitude = busStop.location[0]
            spotPoint.latitude = busStop.location[1]
        }
    }

    private func configureContents() {
        showWebPageView.layer.cornerRadius = 10
        showWebPageView.layer.borderColor = UIColor(hex: "FA6400").cgColor
        showWebPageView.layer.borderWidth = 1.5

        if spot is Shop {
            guard let restaurant = spot as? Shop else { return }
            title = restaurant.name
            guard let imageUrl = URL(string: restaurant.photo.pcPhoto.middle) else { return }
            mainImage.sd_setImage(with: imageUrl)
            shopNameLabel.text = restaurant.name
            valueLabel.text = restaurant.budget.average
            categoryLabel.text = restaurant.genre.name
            directionLabel.text = restaurant.access
            addressLabel.text = restaurant.address
            fromTrainLabel.text = restaurant.access
            businessTimeLabel.text = restaurant.open
            regularHolidayLabel.text = restaurant.close
            seatCountLabel.text = restaurant.capacity
        } else if spot is Station {
            guard let station = spot as? Station else { return }
            title = station.name + "駅"
        } else if spot is BusStopEntity {
            guard let busStop = spot as? BusStopEntity else { return }
            title = busStop.busStopName
        }
    }

    @IBAction private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didSwaipScreen(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SpotDetailsViewController: UITableViewDelegate {
}

extension SpotDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingPoints = settingPoints else { return 0 }
        return settingPoints.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTimePanelCell") as? TravelTimePanelCell else { return TravelTimePanelCell() }
        guard let settingPoint = settingPoints?[indexPath.row] else { return TravelTimePanelCell() }
        cell.configureContents(row: indexPath.row, settingPoint: settingPoint, spotPoint: spotPoint)
        return cell
    }
}
