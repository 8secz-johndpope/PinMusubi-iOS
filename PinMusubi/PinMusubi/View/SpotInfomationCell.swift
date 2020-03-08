//
//  SpotInfomationCell.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

class SpotInfomationCell: UIView {
    @IBOutlet private var infomationImageView: UIImageView!
    @IBOutlet private var infomationLabel: UILabel! {
        didSet {
            infomationLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }

    func setContents(image: UIImage, text: String) {
        infomationImageView.image = image
        infomationLabel.text = text
    }
}
