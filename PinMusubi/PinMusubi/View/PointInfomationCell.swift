//
//  PointInfomationCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// マップ上の地点間の情報を表示するTableViewのカスタムセル
public class PointInfomationCell: UITableViewCell {
    /// 地点名を表示するラベル
    @IBOutlet private var pointNameLabel: UILabel!
    /// 移動時間を表示するラベル
    @IBOutlet private var transferTimeLabel: UILabel!
    /// ピン画像の背景
    @IBOutlet private var whiteView: UIView!
    @IBOutlet private var imageBackgroundView: UIView!
    /// ピン画像
    @IBOutlet private var pinImage: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // 画像の背景の設定
        whiteView.layer.cornerRadius = 17
        imageBackgroundView.layer.cornerRadius = 17
    }

    /// セルが選択された時の処理
    /// - Parameter selected: 選択されたかどうか
    /// - Parameter animated: アニメーションの有無
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
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
    public func setPointInfo(pointName: String, transferTime: Int) {
        pointNameLabel.text = pointName
        if transferTime == -1 {
            transferTimeLabel.text = "?"
        } else if transferTime / 60 == 0 {
            transferTimeLabel.text = String(transferTime) + "分"
        } else {
            transferTimeLabel.text = String(transferTime / 60) + "時間" + String(transferTime % 60) + "分"
        }
    }
}