//
//  TravelTimePanelCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import UIKit

class TravelTimePanelCell: UITableViewCell {
    @IBOutlet private var panelView: UIView! {
        didSet {
            panelView.layer.cornerRadius = 15
            panelView.layer.borderWidth = 1.0
        }
    }

    @IBOutlet private var tagView: UIView! {
        didSet {
            tagView.layer.cornerRadius = 15
            tagView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
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
            transportationGuideButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            transportationGuideButton.layer.borderWidth = 1.0
            transportationGuideButton.layer.cornerRadius = 8
            transportationGuideButton.layer.shadowOpacity = 0.5
            transportationGuideButton.layer.shadowRadius = 3
            transportationGuideButton.layer.shadowColor = UIColor.gray.cgColor
            transportationGuideButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }

    @IBOutlet private var walkingTimeLabel: UILabel! {
        didSet {
            walkingTimeLabel.text = "計測中..."
        }
    }

    @IBOutlet private var drivingTimeLabel: UILabel! {
        didSet {
            drivingTimeLabel.text = "計測中..."
        }
    }

    @IBOutlet private var settingNameLabel: UILabel!

    @IBOutlet private var transitImageView: UIImageView!

    private var transportationGuideURLString = ""
    private var fromStationName = ""
    private var toStationName = ""

    private var presenter: TravelTimePanelPresenterProtcol?

    weak var delegate: TravelTimePanelCellDelegate?

    override  func awakeFromNib() {
        super.awakeFromNib()
        presenter = TravelTimePanelPresenter(view: self, modelType: TravelTimeModel.self)
    }

    override  func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    func configureContents(row: Int, settingPoint: SettingPointEntity, spotPoint: CLLocationCoordinate2D) {
        panelView.layer.borderColor = ColorDefinition.settingPointColors[row].cgColor
        tagView.backgroundColor = ColorDefinition.settingPointColors[row]
        settingNameLabel.text = settingPoint.name

        presenter?.getWalkingTime(settingPoint: settingPoint, pinPoint: spotPoint)
        presenter?.getDrivingTime(settingPoint: settingPoint, pinPoint: spotPoint)
        presenter?.getTransportationGuide(settingPoint: settingPoint, pinPoint: spotPoint)
    }

    func setWalkingTime(walkingTime: Int) {
        if walkingTime == -1 {
            walkingTimeLabel.text = "計測エラー"
        } else if walkingTime == -2 {
            walkingTimeLabel.text = "経路なし"
        } else if walkingTime / 60 == 0 {
            walkingTimeLabel.text = String(walkingTime) + "分"
        } else {
            walkingTimeLabel.text = String(walkingTime / 60) + "時間" + String(walkingTime % 60) + "分"
        }
    }

    func setDrivingTime(drivingTime: Int) {
        if drivingTime == -1 {
            drivingTimeLabel.text = "計測エラー"
        } else if drivingTime == -2 {
            drivingTimeLabel.text = "経路なし"
        } else if drivingTime / 60 == 0 {
            drivingTimeLabel.text = String(drivingTime) + "分"
        } else {
            drivingTimeLabel.text = String(drivingTime / 60) + "時間" + String(drivingTime % 60) + "分"
        }
    }

    func setTransportationGuide(urlString: String, fromStationName: String, toStationName: String) {
        if urlString != "" {
            DispatchQueue.main.async {
                self.transportationGuideURLString = urlString
                self.transportationGuideButton.isEnabled = true
                self.fromStationName = fromStationName
                self.toStationName = toStationName
                self.transportationGuideButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            }
        } else {
            DispatchQueue.main.async {
                self.transportationGuideButton.isEnabled = false
                self.transportationGuideButton.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }

    @IBAction private func didTapTransportationGuideButton(_ sender: Any) {
        let transportationInfomation = UIStoryboard(name: "TransportationInfomationViewController", bundle: nil)
        guard let transportationInfomationVC = transportationInfomation.instantiateInitialViewController() as? TransportationInfomationViewController else { return }
        transportationInfomationVC.setTransportationGuideInfo(urlString: transportationGuideURLString, fromStation: fromStationName, toStation: toStationName)
        delegate?.showTransportationInfomation(instance: transportationInfomationVC)
    }
}
