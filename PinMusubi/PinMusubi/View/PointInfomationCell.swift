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
public class PointInfomationCell: UITableViewCell {
    @IBOutlet private var pointNameLabel: UILabel!

    @IBOutlet private var transferTimeLabel: UILabel! {
        didSet {
            transferTimeLabel.text = "計測中..."
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
            transportationGuideButton.layer.shadowRadius = 1
            transportationGuideButton.layer.shadowColor = UIColor.gray.cgColor
            transportationGuideButton.layer.shadowOffset = CGSize(width: 0, height: 3)
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

    private var transportationGuideURLString = ""

    private var presenter: PointsInfomationPresenterProrocol?

    public weak var delegate: PointInfomationCellDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()

        presenter = PointsInfomationPresenter(view: self, modelType: PointsInfomationModel.self)
    }

    /// セルが選択された時の処理
    /// - Parameter selected: 選択されたかどうか
    /// - Parameter animated: アニメーションの有無
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    /// ピン画像を設定
    /// - Parameter row: 行番号
    public func setPinImage(row: Int) {
        imageBackgroundView.backgroundColor = ColorDefinition.underViewColorsOnModal[row]
        guard let settingPinImage = UIImage(named: "PinOnModal" + String(row)) else { return }
        pinImage.image = settingPinImage
    }

    /// ラベルの設定処理
    /// - Parameter pointName: 地点名
    /// - Parameter transferTime: 移動時間
    public func setPointInfo(settingPoint: SettingPointEntity, pinPoint: CLLocationCoordinate2D, row: Int) {
        if settingPoint.name != "" {
            pointNameLabel.text = settingPoint.name
        } else {
            pointNameLabel.text =  "地点\(String(row + 1))"
        }
        presenter?.getTransferTime(settingPoint: settingPoint, pinPoint: pinPoint)
        presenter?.getTransportationGuide(settingPoint: settingPoint, pinPoint: pinPoint)
    }

    public func setTransferTime(transferTime: Int) {
        if transferTime == -1 {
            transferTimeLabel.text = "計測不可"
        } else if transferTime / 60 == 0 {
            transferTimeLabel.text = String(transferTime) + "分"
        } else {
            transferTimeLabel.text = String(transferTime / 60) + "時間" + String(transferTime % 60) + "分"
        }
    }

    public func setTransportationGuideURLString(urlString: String, status: ResponseStatus) {
        if status == .success {
            DispatchQueue.main.async {
                self.transportationGuideURLString = urlString
                self.transportationGuideButton.isEnabled = true
            }
        } else {
            DispatchQueue.main.async {
                self.transportationGuideButton.isEnabled = false
            }
        }
    }

    public func changeTranspotation(selectedSegmentIndex: Int) {
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
        webVC.setTransportationGuideInfo(urlString: transportationGuideURLString, fromStation: "西船橋", toStation: "氏家")
        delegate?.sendWebVCInstance(webVCInstance: webVC)
    }
}
