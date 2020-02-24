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

        case is Hotels :
            guard let hotels = spot as? Hotels else { return }
            configureHotel(hotels: hotels)

        case is Feature :
            guard let leisure = spot as? Feature else { return }
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
            guard let imageUrl = URL(string: imageURLString) else { return }
            catchImage.sd_setImage(with: imageUrl)
        } else {
            catchImage.image = restaurant.generalImage
        }
    }

    private func configureHotel(hotels: Hotels) {
        title.text = hotels.hotel[0].hotelBasicInfo?.hotelName
        subTitle.text = hotels.hotel[0].hotelBasicInfo?.hotelSpecial
        guard let imageUrlStr = hotels.hotel[0].hotelBasicInfo?.hotelThumbnailURL else { return }
        guard let imageUrl = URL(string: imageUrlStr) else { return }
        catchImage.sd_setImage(with: imageUrl)
    }

    private func configureLeisure(leisure: Feature) {
        title.text = leisure.name
        subTitle.text = leisure.property.genre[0].name
        guard let imageUrlStr = leisure.property.leadImage else { return }
        if imageUrlStr.contains("1.jpg") || imageUrlStr.contains("loco_image") || imageUrlStr.contains("photo_image1-thumb") || imageUrlStr.contains("top.jpg") {
            catchImage.image = UIImage(named: "NoImage")
        } else {
            guard let imageUrl = URL(string: imageUrlStr) else { return }
            catchImage.sd_setImage(with: imageUrl)
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
