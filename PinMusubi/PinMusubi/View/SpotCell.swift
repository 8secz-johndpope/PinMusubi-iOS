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
    @IBOutlet private var imageBackView: UIView!
    @IBOutlet private var catchImage: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!
    @IBOutlet private var adBaseView: UIView!

    private var adBannerView: GADBannerView?

    override public func awakeFromNib() {
        super.awakeFromNib()
        imageBackView.backgroundColor = .lightGray
        imageBackView?.layer.cornerRadius = 10
        catchImage.layer.cornerRadius = 10
    }

    public func initialize() {
        catchImage.image = nil
    }

    public func configure(spot: SpotEntityProtocol) {
        adBaseView.isHidden = true

        switch spot {
        case is Shop:
            guard let restaurant = spot as? Shop else { return }
            title.text = restaurant.name
            subTitle.text = restaurant.genre.name
            guard let imageUrl = URL(string: restaurant.photo.pcPhoto.large) else { return }
            catchImage.sd_setImage(with: imageUrl)

        case is Station :
            guard let station = spot as? Station else { return }
            title.text = station.name + "駅"
            subTitle.text = station.line
            if #available(iOS 13.0, *) {
                imageBackView.backgroundColor = UIColor.systemBackground
            } else {
                imageBackView.backgroundColor = UIColor.white
            }
            catchImage.image = UIImage(named: "Train")

        case is BusStopEntity :
            guard let busStop = spot as? BusStopEntity else { return }
            title.text = busStop.busStopName
            subTitle.text = busStop.busLineName
            if #available(iOS 13.0, *) {
                imageBackView.backgroundColor = UIColor.systemBackground
            } else {
                imageBackView.backgroundColor = UIColor.white
            }
            catchImage.image = UIImage(named: "Bus")

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
}
