//
//  PointInfomationCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

/// マップ上の地点間の情報を表示するTableViewのカスタムセル
internal class PointInfomationCell: UITableViewCell {
    @IBOutlet private var pointNameLabel: UILabel!

    @IBOutlet private var transferTimeLabel: UILabel! {
        didSet {
            transferTimeLabel.text = "計測中..."
            transferTimeLabel.isHidden = false
        }
    }

    @IBOutlet private var transportationGuideButton: UIButton! {
        didSet {
            if #available(iOS 13.0, *) {
                transportationGuideButton.backgroundColor = .tertiarySystemBackground
            } else {
                transportationGuideButton.backgroundColor = .white
            }
            transportationGuideButton.tintColor = UIColor(hex: "FA6400")
            transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
            transportationGuideButton.layer.borderWidth = 1.0
            transportationGuideButton.layer.cornerRadius = 8
            transportationGuideButton.layer.shadowOpacity = 0.5
            transportationGuideButton.layer.shadowRadius = 3
            transportationGuideButton.layer.shadowColor = UIColor.gray.cgColor
            transportationGuideButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            transportationGuideButton.isHidden = true
            transportationGuideButton.isEnabled = false
        }
    }

    @IBOutlet private var whiteView: UIView! {
        didSet {
            whiteView.layer.cornerRadius = 17
        }
    }

    @IBOutlet private var imageBackgroundView: UIView! {
        didSet {
            imageBackgroundView.layer.cornerRadius = 17
        }
    }

    @IBOutlet private var pinImage: UIImageView!

    private var pointInfomation: PointInfomationEntity?

    internal weak var delegate: PointInfomationCellDelegate?

    override internal func awakeFromNib() {
        super.awakeFromNib()
    }

    /// セルが選択された時の処理
    /// - Parameter selected: 選択されたかどうか
    /// - Parameter animated: アニメーションの有無
    override internal func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    internal func initPointInfomation() {
        pointInfomation = nil
        transferTimeLabel.text = "計測中..."
        transportationGuideButton.isEnabled = false
        transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    internal func setPointInfomation(pointName: String, row: Int) {
        pointNameLabel.text = pointName
        setPinImage(row: row)
    }

    internal func setTransportationInformation(pointInfomation: PointInfomationEntity) {
        self.pointInfomation = pointInfomation
        setTravelTime(transferTime: pointInfomation.travelTime)
        setEnabledTransferGuidButton(status: pointInfomation.transferGuideResponseStatus)
    }

    /// ピン画像を設定
    /// - Parameter row: 行番号
    private func setPinImage(row: Int) {
        imageBackgroundView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let settingPinImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImage.image = settingPinImage
    }

    private func setTravelTime(transferTime: Int) {
        if transferTime == -1 {
            transferTimeLabel.text = "計測不可"
        } else if transferTime / 60 == 0 {
            transferTimeLabel.text = String(transferTime) + "分"
        } else {
            transferTimeLabel.text = String(transferTime / 60) + "時間" + String(transferTime % 60) + "分"
        }
    }

    private func setEnabledTransferGuidButton(status: ResponseStatus) {
        if status == .success {
            transportationGuideButton.isEnabled = true
            transportationGuideButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
        } else {
            transportationGuideButton.isEnabled = false
            transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    internal func changeTranspotation(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            transferTimeLabel.isHidden = false
            transportationGuideButton.isHidden = true

        case 1:
            transferTimeLabel.isHidden = true
            transportationGuideButton.isHidden = false

        default:
            break
        }
    }

    @IBAction private func didTapTransportationGuideButton(_ sender: Any) {
        let webView = UIStoryboard(name: "WebView", bundle: nil)
        guard let webVC = webView.instantiateInitialViewController() as? WebViewController else { return }
        guard let pointInfomation = pointInfomation else { return }
        webVC.setTransportationGuideInfo(urlString: pointInfomation.transferGuideURLString, fromStation: pointInfomation.fromStationName, toStation: pointInfomation.toStationName)
        delegate?.sendWebVCInstance(webVCInstance: webVC)
    }
}
