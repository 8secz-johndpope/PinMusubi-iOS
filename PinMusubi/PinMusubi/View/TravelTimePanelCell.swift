//
//  TravelTimePanelCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import UIKit

public class TravelTimePanelCell: UITableViewCell {
    @IBOutlet private var panelView: UIView!
    @IBOutlet private var tagView: UIView!
    @IBOutlet private var settingNameLabel: UILabel!
    @IBOutlet private var walkingTimeLabel: UILabel!
    @IBOutlet private var drivingTimeLabel: UILabel!
    @IBOutlet private var transitTimeLabel: UILabel!
    @IBOutlet private var transitImageView: UIImageView!

    private var presenter: TravelTimePanelPresenterProtcol?

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.presenter = TravelTimePanelPresenter(view: self, modelType: TravelTimeModel.self)
        panelView.layer.cornerRadius = 15
        panelView.layer.borderColor = UIColor.lightGray.cgColor
        panelView.layer.borderWidth = 1.0
        tagView.layer.cornerRadius = 15
        tagView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }

    public func configureContents(row: Int, settingPoint: SettingPointEntity, spotPoint: CLLocationCoordinate2D) {
        tagView.backgroundColor = ColorDefinition.settingPointColors[row]
        settingNameLabel.text = settingPoint.name
        // 徒歩
        presenter?.getPointsInfomation(settingPoint: settingPoint, pinPoint: spotPoint, transportType: .walking, complete: { travelTime in
            let label = "徒歩："
            if travelTime == -1 {
                self.walkingTimeLabel.text = label + "？"
            } else if travelTime == -2 {
                self.walkingTimeLabel.text = label + "経路なし"
            } else {
                self.walkingTimeLabel.text = label + String(travelTime) + "分"
            }
        }
        )
        // 自動車
        presenter?.getPointsInfomation(settingPoint: settingPoint, pinPoint: spotPoint, transportType: .automobile, complete: { travelTime in
            let label = "車："
            if travelTime == -1 {
                self.drivingTimeLabel.text = label + "？"
            } else if travelTime == -2 {
                self.walkingTimeLabel.text = label + "経路なし"
            } else {
                self.drivingTimeLabel.text = label + String(travelTime) + "分"
            }
        }
        )
        // 交通機関
        transitTimeLabel.text = "Comming Soon..."
        //        presenter?.getPointsInfomation(settingPoint: settingPoint, pinPoint: spotPoint, transportType: .transit, complete: { travelTime in
        //            let label = "交通機関："
        //            if travelTime == -1 {
        //                self.transitTimeLabel.text = label + "？"
        //            } else if travelTime == -2 {
        //                self.walkingTimeLabel.text = label + "経路なし"
        //            } else {
        //                self.transitTimeLabel.text = label + String(travelTime) + "分"
        //            }
        //        }
        //        )
    }
}
