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

class SpotCell: UITableViewCell {
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

    func configure(spot: SpotEntityProtocol) {
        adBaseView.isHidden = true

        if let spot = spot as? SpotEntity {
            title.text = spot.name
            subTitle.text = spot.category
            if let imageURLString = spot.imageURLString {
                if imageURLString.contains("1.jpg") ||
                    imageURLString.contains("loco_image") ||
                    imageURLString.contains("photo_image1-thumb") ||
                    imageURLString.contains("top.jpg") {
                    catchImage.image = UIImage(named: "holiday")
                    imageBackView.backgroundColor = UIColor(hex: "FCFFE1")
                } else {
                    guard let imageURL = URL(string: imageURLString) else { return }
                    catchImage.sd_setImage(with: imageURL)
                    if #available(iOS 13.0, *) {
                        imageBackView?.backgroundColor = UIColor.systemBackground
                    } else {
                        imageBackView?.backgroundColor = UIColor.white
                    }
                }
            } else {
                catchImage.image = UIImage(named: spot.generalImageName ?? "holiday")
                imageBackView.backgroundColor = UIColor(hex: "FCFFE1")
            }
        } else {
            adBaseView.isHidden = false
            guard let adBannerView = adBannerView else { return }
            adBaseView.addSubview(adBannerView)
        }
    }

    func addAd(adBannerView: GADBannerView) {
        adBannerView.frame.size = CGSize(width: frame.width, height: frame.height)
        self.adBannerView = adBannerView
    }
}
