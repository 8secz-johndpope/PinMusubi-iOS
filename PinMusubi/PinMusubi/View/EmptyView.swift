//
//  EmptyView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// 空データのType
public enum EmptyType {
    /// 飲食店
    case restaurant
    /// 宿泊
    case hotel
    /// レジャー
    case leisure
    /// 交通機関
    case station
    /// お気に入り
    case favorite
    /// 検索履歴
    case history
}

public class EmptyView: UIView {
    @IBOutlet private var emptyImage: UIImageView!
    @IBOutlet private var emptyTitle: UILabel!

    public func setEmptyType(emptyType: EmptyType) {
        if emptyType == .restaurant {
            emptyImage.image = UIImage(named: "EmptyRestaurant")
            emptyTitle.text = "このスポット付近の飲食店が\n見つかりませんでした"
        } else if emptyType == .hotel {
            emptyImage.image = UIImage(named: "EmptyHotel")
            emptyTitle.text = "このスポット付近の宿泊施設が\n見つかりませんでした"
        } else if emptyType == .leisure {
            emptyImage.image = UIImage(named: "EmptyLeisure")
            emptyTitle.text = "このスポット付近のレジャー施設が\n見つかりませんでした"
        } else if emptyType == .station {
            emptyImage.image = UIImage(named: "EmptyStation")
            emptyTitle.text = "このスポット付近の駅・バス停が\n見つかりませんでした"
        } else if emptyType == .favorite {
            emptyImage.image = UIImage(named: "EmptyFavorite")
            emptyTitle.text = "まだお気に入りに追加された\nスポットはありません"
        } else if emptyType == .history {
            emptyImage.image = UIImage(named: "EmptyHistory")
            emptyTitle.text = "まだ１度もスポットの検索が\nされていません"
        }
    }
}
