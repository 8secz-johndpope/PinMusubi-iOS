//
//  SpotCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds
import SDWebImage
import UIKit

public class SpotCell: UITableViewCell {
    @IBOutlet private var imageBackView: UIView! {
        didSet {
            imageBackView?.layer.cornerRadius = 10
        }
    }

    @IBOutlet private var catchImage: UIImageView! {
        didSet {
            catchImage.layer.cornerRadius = 10
        }
    }

    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!
    @IBOutlet private var adBaseView: UIView!

    private var adBannerView: GADBannerView?

    public func initialize() {
        catchImage.image = nil
    }

    public func configure(spot: SpotEntityProtocol) {
        adBaseView.isHidden = true

        switch spot {
        case is RestaurantEntity:
            guard let restaurant = spot as? RestaurantEntity else { return }
            configureRestaurant(restaurant: restaurant)

        case is HotelEntity :
            guard let hotel = spot as? HotelEntity else { return }
            configureHotel(hotel: hotel)

        case is LeisureEntity :
            guard let leisure = spot as? LeisureEntity else { return }
            configureLeisure(leisure: leisure)

        case is Station :
            guard let station = spot as? Station else { return }
            configureStation(station: station)

        case is BusStopEntity :
            guard let busStop = spot as? BusStopEntity else { return }
            configureBusStop(busStop: busStop)

        default:
            adBaseView.isHidden = false
            guard let adBannerView = adBannerView else { return }
            adBaseView.addSubview(adBannerView)
        }
    }

    public func addAd(adBannerView: GADBannerView) {
        adBannerView.frame.size = CGSize(width: frame.width, height: frame.height)
        self.adBannerView = adBannerView
    }

    private func configureRestaurant(restaurant: RestaurantEntity) {
        title.text = restaurant.name
        subTitle.text = restaurant.category
        if let imageURLString = restaurant.imageURLString {
            guard let imageURL = URL(string: imageURLString) else { return }
            catchImage.sd_setImage(with: imageURL)
        } else {
            catchImage.image = UIImage(named: restaurant.generalImage ?? "")
        }
    }

    private func configureHotel(hotel: HotelEntity) {
        title.text = hotel.name
        subTitle.text = hotel.category
        if let imageURLString = hotel.imageURLString {
            guard let imageURL = URL(string: imageURLString) else { return }
            catchImage.sd_setImage(with: imageURL)
        } else {
            catchImage.image = UIImage(named: hotel.generalImage ?? "")
        }
    }

    private func configureLeisure(leisure: LeisureEntity) {
        title.text = leisure.name
        subTitle.text = leisure.category
        if let imageURLString = leisure.imageURLString {
            if imageURLString.contains("1.jpg") ||
                imageURLString.contains("loco_image") ||
                imageURLString.contains("photo_image1-thumb") ||
                imageURLString.contains("top.jpg") {
                catchImage.image = UIImage(named: "holiday")
            } else {
                guard let imageURL = URL(string: imageURLString) else { return }
                catchImage.sd_setImage(with: imageURL)
            }
        } else {
            catchImage.image = UIImage(named: leisure.generalImage ?? "holiday")
        }
    }

    private func configureStation(station: Station) {
        title.text = station.name + "駅"
        subTitle.text = station.line
        catchImage.image = UIImage(named: "Train")
    }

    private func configureBusStop(busStop: BusStopEntity) {
        title.text = busStop.busStopName
        subTitle.text = busStop.busLineName
        catchImage.image = UIImage(named: "Bus")
    }
}
