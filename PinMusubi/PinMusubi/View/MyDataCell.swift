//
//  MyDataCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Cosmos
import MapKit
import UIKit

public class MyDataCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var registerDateLabel: UILabel!
    @IBOutlet private var ratingView: CosmosView!

    public func configure(myDataType: MyDataEntityProtocol) {
        let format = DateFormatter()
        format.timeStyle = .medium
        format.dateStyle = .medium

        if let favoriteData = myDataType as? FavoriteSpotEntity {
            titleLabel.text = favoriteData.title
            subTitleLabel.text = favoriteData.memo
            registerDateLabel.text = format.string(from: favoriteData.dateTime)
            ratingView.rating = favoriteData.rating
        } else if let historyData = myDataType as? SearchHistoryEntity {
            var title = ""
            var imageCount = 0
            for settingPointInfo in historyData.settingPointEntityList {
                if imageCount != 0 {
                    title += " - "
                }
                title += settingPointInfo.name
                imageCount += 1
            }
            titleLabel.text = title
            registerDateLabel.text = format.string(from: historyData.dateTime)
            ratingView.settings.filledImage = UIImage(named: "Pin")
            ratingView.settings.emptyImage = UIImage(named: "EmptyPin")
            ratingView.settings.fillMode = .half
            ratingView.rating = Double(imageCount / 2)

            // マイグレーション：中間地点の名称をDBに設定する
            if historyData.address == "" {
                let coordinate = CLLocationCoordinate2D(latitude: historyData.halfwayPointLatitude, longitude: historyData.halfwayPointLongitude )
                let model = SearchInterestPlaceModel()
                model.getAddress(point: coordinate) { address, _ in
                    DispatchQueue.main.async {
                        historyData.address = address
                        _ = SearchHistoryAccessor().set(data: historyData)
                        self.subTitleLabel.text = "中間地点：\(address)"
                    }
                }
            } else {
                subTitleLabel.text = "中間地点：\(historyData.address)"
            }
        }
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
