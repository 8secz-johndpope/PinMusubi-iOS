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
class PointInfomationCell: UITableViewCell {
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

    weak var delegate: PointInfomationCellDelegate?

    override  func awakeFromNib() {
        super.awakeFromNib()
    }

    /// セルが選択された時の処理
    /// - Parameter selected: 選択されたかどうか
    /// - Parameter animated: アニメーションの有無
    override  func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    func initPointInfomation() {
        pointInfomation = nil
        transferTimeLabel.text = "計測中..."
        transportationGuideButton.isEnabled = false
        transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    func setPointInfomation(pointName: String, row: Int) {
        pointNameLabel.text = pointName
        setPinImage(row: row)
    }

    func setTransportationInformation(pointInfomation: PointInfomationEntity) {
        self.pointInfomation = pointInfomation
        setEnabledTransferGuidButton(enable: pointInfomation.transferGuideURLString != "")
    }

    /// ピン画像を設定
    /// - Parameter row: 行番号
    private func setPinImage(row: Int) {
        imageBackgroundView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let settingPinImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImage.image = settingPinImage
    }

    private func setTravelTime(transferTime: Int?) {
        guard let transferTime = transferTime else {
            transferTimeLabel.text = "計測中..."
            return
        }

        if transferTime == -1 {
            transferTimeLabel.text = "計測エラー"
        } else if transferTime / 60 == 0 {
            transferTimeLabel.text = String(transferTime) + "分"
        } else {
            transferTimeLabel.text = String(transferTime / 60) + "時間" + String(transferTime % 60) + "分"
        }
    }

    private func setDistance(distance: Double?) {
        guard let distance = distance else {
            transferTimeLabel.text = "計測中..."
            return
        }

        if distance == -1 {
            transferTimeLabel.text = "計測エラー"
        } else if distance < 1_000 {
            transferTimeLabel.text = String(distance) + " m"
        } else {
            transferTimeLabel.text = String(distance / 1_000) + " km"
        }
    }

    private func setEnabledTransferGuidButton(enable: Bool) {
        if enable {
            transportationGuideButton.isEnabled = true
            transportationGuideButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
        } else {
            transportationGuideButton.isEnabled = false
            transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    func replaceTranspotation(transportation: Transportation) {
        switch transportation {
        case .walk:
            transferTimeLabel.isHidden = false
            transportationGuideButton.isHidden = true
            setTravelTime(transferTime: pointInfomation?.walkTime)

        case .bicycle:
            transferTimeLabel.isHidden = false
            transportationGuideButton.isHidden = true
            setTravelTime(transferTime: pointInfomation?.bicycleTime)

        case .car:
            transferTimeLabel.isHidden = false
            transportationGuideButton.isHidden = true
            setTravelTime(transferTime: pointInfomation?.carTime)

        case .train:
            transferTimeLabel.isHidden = true
            transportationGuideButton.isHidden = false

        case .distance:
            transferTimeLabel.isHidden = false
            transportationGuideButton.isHidden = true
            setDistance(distance: pointInfomation?.distance)
        }
    }

    @IBAction private func didTapTransportationGuideButton(_ sender: Any) {
        let transportationInfomation = UIStoryboard(name: "TransportationInfomationViewController", bundle: nil)
        guard let transportationInfomationVC = transportationInfomation.instantiateInitialViewController() as? TransportationInfomationViewController else { return }
        guard let transferGuideURLString = pointInfomation?.transferGuideURLString,
            let fromStationName = pointInfomation?.fromStationName,
            let toStationName = pointInfomation?.toStationName else { return }
        transportationInfomationVC.setTransportationGuideInfo(urlString: transferGuideURLString, fromStation: fromStationName, toStation: toStationName)
        delegate?.sendInstance(instance: transportationInfomationVC)
    }
}
