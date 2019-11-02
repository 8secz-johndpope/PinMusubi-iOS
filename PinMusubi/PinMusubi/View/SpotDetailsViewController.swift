//
//  SpotDetailsViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/31.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import MapKit
import SDWebImage
import UIKit

public class SpotDetailsViewController: UIViewController {
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var valueImageView: UIImageView!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var showWebPageView: UIView!
    @IBOutlet private var showWebPageLabel: UILabel!
    @IBOutlet private var baseInfoView: UIView!
    @IBOutlet private var baseInfoMapView: MKMapView!
    @IBOutlet private var travelTimePanelTableView: UITableView!

    private var settingPoints: [SettingPointEntity]?
    private var spot: SpotEntityProtocol?
    private var spotPoint = CLLocationCoordinate2D()

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureContents()
        configureMap()

        travelTimePanelTableView.delegate = self
        travelTimePanelTableView.dataSource = self
        travelTimePanelTableView.register(UINib(nibName: "TravelTimePanelCell", bundle: nil), forCellReuseIdentifier: "TravelTimePanelCell")

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapShowWebView(recognizer:)))
        longPressGesture.minimumPressDuration = 0
        showWebPageView.addGestureRecognizer(longPressGesture)
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

        if let shop = spot as? Shop {
            title = shop.name
            guard let imageUrl = URL(string: shop.photo.pcPhoto.middle) else { return }
            mainImage.sd_setImage(with: imageUrl)
            nameLabel.text = shop.name
            valueLabel.text = shop.budget.average
            categoryLabel.text = shop.genre.name
            directionLabel.text = shop.access
            baseInfoMapView.removeFromSuperview()
            guard let spotBaseInfoView = UINib(nibName: "SpotBaseInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? SpotBaseInfoView else { return }
            spotBaseInfoView.configureLabel(shop: shop)
            baseInfoView.addSubview(spotBaseInfoView)
        } else if let station = spot as? Station {
            title = station.name + "駅"
            mainImage.image = UIImage(named: "Train")
            nameLabel.text = station.name + "駅"
            var prevStation = "なし"
            var nextStation = "なし"
            if station.prev != nil {
                guard let prev = station.prev else { return }
                prevStation = prev
            }
            if station.next != nil {
                guard let next = station.next else { return }
                nextStation = next
            }
            valueImageView.image = UIImage(named: "Station")
            valueLabel.text = "前の駅：" + prevStation + "駅" + " / " + "次の駅：" + nextStation + "駅"
            categoryLabel.text = station.prefecture + "県"
            directionLabel.text = station.line
            showWebPageView.isHidden = true
        } else if let busStop = spot as? BusStopEntity {
            title = busStop.busStopName
            mainImage.image = UIImage(named: "Bus")
            nameLabel.text = busStop.busStopName + "バス停"
            valueImageView.isHidden = true
            valueLabel.text = ""
            categoryLabel.text = busStop.busLineName
            directionLabel.text = busStop.busOperationCompany
            showWebPageView.isHidden = true
        }
    }

    private func configureMap() {
        // region
        var region: MKCoordinateRegion = baseInfoMapView.region
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001

        // annotation
        let spotPointAnnotation = MKPointAnnotation()
        if let station = spot as? Station {
            let stationCoordinate = CLLocationCoordinate2D(latitude: station.lat, longitude: station.lng)
            spotPointAnnotation.coordinate = stationCoordinate
            spotPointAnnotation.title = station.name
            spotPointAnnotation.subtitle = station.line
            region.center = stationCoordinate
        } else if let busStation = spot as? BusStopEntity {
            let busStationCoodinate = CLLocationCoordinate2D(latitude: busStation.location[1], longitude: busStation.location[0])
            spotPointAnnotation.coordinate = busStationCoodinate
            spotPointAnnotation.title = busStation.busStopName
            spotPointAnnotation.subtitle = busStation.busLineName
            region.center = busStationCoodinate
        }
        baseInfoMapView.setRegion(region, animated: false)
        baseInfoMapView.addAnnotation(spotPointAnnotation)
    }

    @IBAction private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didSwaipScreen(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func didTapShowWebView(recognizer: UILongPressGestureRecognizer) {
        guard let shop = spot as? Shop else { return }

        switch recognizer.state {
        case .possible: break

        case .began:
            showWebPageView.backgroundColor = UIColor(hex: "FA6400")
            showWebPageLabel.textColor = UIColor.white

        case .changed: break

        case .ended:
            if #available(iOS 13.0, *) {
                showWebPageView.backgroundColor = UIColor.systemBackground
            } else {
                showWebPageView.backgroundColor = UIColor.white
            }
            showWebPageLabel.textColor = UIColor(hex: "FA6400")
            let webView = UIStoryboard(name: "WebView", bundle: nil)
            guard let webVC = webView.instantiateInitialViewController() as? WebViewController else { return }
            webVC.setParameter(shop: shop)
            navigationController?.show(webVC, sender: nil)

        case .cancelled: break

        case .failed: break

        @unknown default: break
        }
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
