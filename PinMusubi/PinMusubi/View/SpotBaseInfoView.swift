//
//  SpotBaseInfoView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotBaseInfoView: UIView {
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var fromTrainLabel: UILabel!
    @IBOutlet private var businessTimeLabel: UILabel!
    @IBOutlet private var regularHolidayLabel: UILabel!
    @IBOutlet private var seatCountLabel: UILabel!

    @IBOutlet private var image1: UIImageView!
    @IBOutlet private var image2: UIImageView!
    @IBOutlet private var image3: UIImageView!
    @IBOutlet private var image4: UIImageView!
    @IBOutlet private var image5: UIImageView!

    public func configureLabel(spot: SpotEntityProtocol) {
        if let restaurant = spot as? RestaurantEntity {
            addressLabel.text = restaurant.address
            fromTrainLabel.text = restaurant.access
            businessTimeLabel.text = restaurant.open
            regularHolidayLabel.text = restaurant.close
            seatCountLabel.text = restaurant.phoneNumber
        } else if let hotel = spot as? HotelEntity {
            addressLabel.text = hotel.address
            fromTrainLabel.text = hotel.access
            businessTimeLabel.text = hotel.phoneNumber
            regularHolidayLabel.text = hotel.special
            seatCountLabel.text = hotel.reviewAverage

            image3.image = UIImage(named: "MinPhone")
            image4.image = UIImage(named: "MinParking")
            image5.image = UIImage(named: "MinStar")
        } else if let leisure = spot as? Feature {
            addressLabel.text = leisure.property.address
            if !leisure.property.station.isEmpty {
                fromTrainLabel.text = leisure.property.station[0].railway
                regularHolidayLabel.text = "最寄り駅から徒歩" + leisure.property.station[0].time + "分"
            }
            businessTimeLabel.text = leisure.property.tel1
            seatCountLabel.text = leisure.featureDescription

            image3.image = UIImage(named: "MinPhone")
            image4.image = UIImage(named: "MinWalking")
            image5.image = UIImage(named: "MinStar")
        }
    }
}
