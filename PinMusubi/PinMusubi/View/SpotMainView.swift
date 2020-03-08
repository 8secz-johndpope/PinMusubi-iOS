//
//  SpotMainView.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

class SpotMainView: UIView {
    @IBOutlet private var imageBackgroundView: UIView! {
        didSet {
            imageBackgroundView.layer.cornerRadius = 20
        }
    }

    @IBOutlet private var mainImageView: UIImageView! {
        didSet {
            mainImageView.layer.cornerRadius = 20
        }
    }

    var spot: SpotEntity?

    func setLayout() {
        let imageHeight = mainImageView.image?.size.height ?? 0.0
        let imageWidth = mainImageView.image?.size.width ?? 0.0

        // imageBackgroundView
        let resizedWidth = UIScreen.main.bounds.width - 40
        let resizedHeight = resizedWidth * CGFloat(imageHeight / imageWidth)
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.heightAnchor.constraint(equalToConstant: resizedHeight).isActive = true
        imageBackgroundView.widthAnchor.constraint(equalToConstant: resizedWidth).isActive = true
    }

    func setContents(spot: SpotEntity) {
        if let imageURLString = spot.imageURLString {
            if imageURLString.contains("1.jpg") ||
                imageURLString.contains("loco_image") ||
                imageURLString.contains("photo_image1-thumb") ||
                imageURLString.contains("top.jpg") {
                mainImageView.image = UIImage(named: "holiday")
            } else {
                guard let imageURL = URL(string: imageURLString) else { return }
                mainImageView.sd_setImage(with: imageURL)
            }
        } else {
            mainImageView.image = UIImage(named: spot.generalImageName ?? "holiday")
        }
    }
}
