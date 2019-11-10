//
//  MyPageCollectionViewCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/07.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// myDataを表示するCollectionCellのDelegate
public protocol MyPageCollectionViewCellDelegate: AnyObject {
    /// myData詳細画面を表示
    func showSpotDetailsView(myData: MyDataEntityProtocol)
}
