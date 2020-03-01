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
    @IBOutlet private var showWebPageButtonView: UIView! {
        didSet {
            showWebPageButtonView.layer.cornerRadius = 10
            showWebPageButtonView.layer.borderColor = UIColor(hex: "FA6400").cgColor
            showWebPageButtonView.layer.borderWidth = 1.5
            showWebPageButtonView.layer.shadowOpacity = 0.5
            showWebPageButtonView.layer.shadowRadius = 3
            showWebPageButtonView.layer.shadowColor = UIColor.gray.cgColor
            showWebPageButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)

            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapShowWebView(recognizer:)))
            longPressGesture.minimumPressDuration = 0
            showWebPageButtonView.addGestureRecognizer(longPressGesture)
        }
    }

    @IBOutlet private var travelTimePanelTableView: UITableView! {
        didSet {
            travelTimePanelTableView.delegate = self
            travelTimePanelTableView.dataSource = self
            travelTimePanelTableView.register(UINib(nibName: "TravelTimePanelCell", bundle: nil), forCellReuseIdentifier: "TravelTimePanelCell")
        }
    }

    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var valueImageView: UIImageView!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var showWebPageLabel: UILabel!
    @IBOutlet private var baseInfoView: UIView!
    @IBOutlet private var baseInfoMapView: MKMapView!

    private var settingPoints: [SettingPointEntity]?
    private var spot: SpotEntityProtocol?
    private var spotPoint = CLLocationCoordinate2D()

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureContents()
        configureMap()
    }

    public func setParameter(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol) {
        self.settingPoints = settingPoints
        self.spot = spot
        if spot is RestaurantEntity {
            guard let restaurant = spot as? RestaurantEntity else { return }
            spotPoint.latitude = restaurant.latitude
            spotPoint.longitude = restaurant.longitude
        } else if spot is HotelEntity {
            guard let hotel = spot as? HotelEntity else { return }
            spotPoint.latitude = hotel.latitude
            spotPoint.longitude = hotel.longitude
        } else if spot is LeisureEntity {
            guard let leisure = spot as? LeisureEntity else { return }
            spotPoint.latitude = leisure.latitude
            spotPoint.longitude = leisure.longitude
        } else if spot is TransportationEntity {
            guard let transportation = spot as? TransportationEntity else { return }
            spotPoint.latitude = transportation.latitude
            spotPoint.longitude = transportation.longitude
        }
    }

    private func configureContents() {
        if let restaurant = spot as? RestaurantEntity {
            configureRestaurant(restaurant: restaurant)
        } else if let hotel = spot as? HotelEntity {
            configureHotel(hotel: hotel)
        } else if let leisure = spot as? LeisureEntity {
            configureLeisure(leisure: leisure)
        } else if let transportation = spot as? TransportationEntity {
            configureTransportation(transportation: transportation)
        }
    }

    private func configureRestaurant(restaurant: RestaurantEntity) {
        title = restaurant.name
        nameLabel.text = restaurant.name
        valueLabel.text = restaurant.price
        categoryLabel.text = restaurant.category
        directionLabel.text = restaurant.access
        showWebPageLabel.text = "Webで詳しく見る・予約する"

        baseInfoMapView.removeFromSuperview()
        guard let spotBaseInfoView = UINib(nibName: "SpotBaseInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? SpotBaseInfoView else { return }
        spotBaseInfoView.configureLabel(spot: restaurant)
        baseInfoView.addSubview(spotBaseInfoView)

        if let imageURLString = restaurant.imageURLString {
            guard let imageURL = URL(string: imageURLString) else { return }
            mainImage.sd_setImage(with: imageURL)
        } else {
            mainImage.image = UIImage(named: restaurant.generalImage ?? "")
        }
    }

    private func configureHotel(hotel: HotelEntity) {
        title = hotel.name
        nameLabel.text = hotel.name
        valueLabel.text = hotel.reviewAverage
        valueImageView.image = UIImage(named: "Star")
        categoryLabel.text = hotel.category
        directionLabel.text = hotel.special
        showWebPageLabel.text = "Webで詳しく見る・予約する"

        baseInfoMapView.removeFromSuperview()
        guard let spotBaseInfoView = UINib(nibName: "SpotBaseInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? SpotBaseInfoView else { return }
        spotBaseInfoView.configureLabel(spot: hotel)
        baseInfoView.addSubview(spotBaseInfoView)

        if let imageURLString = hotel.imageURLString {
            guard let imageURL = URL(string: imageURLString) else { return }
            mainImage.sd_setImage(with: imageURL)
        } else {
            mainImage.image = UIImage(named: hotel.generalImage ?? "")
        }
    }

    private func configureLeisure(leisure: LeisureEntity) {
        title = leisure.name
        nameLabel.text = leisure.name
        valueImageView.image = UIImage(named: "StationIcon")
        if let nearStation = leisure.nearStation {
            valueLabel.text = "最寄り駅：\(nearStation)駅"
        } else {
            valueLabel.text = "最寄り駅：情報なし"
        }
        categoryLabel.text = leisure.category
        directionLabel.text = leisure.description
        showWebPageLabel.text = "Webで詳しく調べてみる"

        baseInfoMapView.removeFromSuperview()
        guard let spotBaseInfoView = UINib(nibName: "SpotBaseInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? SpotBaseInfoView else { return }
        spotBaseInfoView.configureLabel(spot: leisure)
        baseInfoView.addSubview(spotBaseInfoView)

        if let imageURLString = leisure.imageURLString {
            if imageURLString.contains("1.jpg") ||
                imageURLString.contains("loco_image") ||
                imageURLString.contains("photo_image1-thumb") ||
                imageURLString.contains("top.jpg") {
                mainImage.image = UIImage(named: "holiday")
            } else {
                guard let imageURL = URL(string: imageURLString) else { return }
                mainImage.sd_setImage(with: imageURL)
            }
        } else {
            mainImage.image = UIImage(named: leisure.generalImage ?? "holiday")
        }
    }

    private func configureTransportation(transportation: TransportationEntity) {
        title = transportation.name
        mainImage.image = UIImage(named: transportation.image)
        nameLabel.text = transportation.name
        valueImageView.image = UIImage(named: "StationIcon")
        valueLabel.text = transportation.address
        categoryLabel.text = transportation.category
        directionLabel.text = "距離：\(transportation.distance)m"
        showWebPageButtonView.isHidden = true
    }

    private func configureMap() {
        guard let latitude = spot?.latitude, let longitude = spot?.longitude else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // region
        var region: MKCoordinateRegion = baseInfoMapView.region
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        region.center = coordinate

        // annotation
        let spotPointAnnotation = MKPointAnnotation()
        spotPointAnnotation.coordinate = coordinate
        spotPointAnnotation.title = spot?.name
        spotPointAnnotation.subtitle = spot?.category

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
        switch recognizer.state {
        case .possible: break

        case .began:
            showWebPageButtonView.backgroundColor = UIColor(hex: "FA6400")
            showWebPageLabel.textColor = UIColor.white

        case .changed: break

        case .ended:
            if #available(iOS 13.0, *) {
                showWebPageButtonView.backgroundColor = UIColor.systemBackground
            } else {
                showWebPageButtonView.backgroundColor = UIColor.white
            }
            showWebPageLabel.textColor = UIColor(hex: "FA6400")
            let webView = UIStoryboard(name: "WebView", bundle: nil)
            guard let webVC = webView.instantiateInitialViewController() as? WebViewController else { return }
            guard let spot = spot else { return }
            webVC.setSpot(spot: spot)
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
        cell.delegate = self
        return cell
    }
}

extension SpotDetailsViewController: TravelTimePanelCellDelegate {
    public func showWebPage(webVCInstance: WebViewController) {
        present(webVCInstance, animated: true, completion: nil)
    }
}
