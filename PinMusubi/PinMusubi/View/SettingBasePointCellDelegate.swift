//
//  SettingBasePointCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// 検索条件セルのDelegate
public protocol SettingBasePointCellDelegate: AnyObject {
    func setEditingCell(editingCell: SettingBasePointCell)

    func hideActionButton()

    func setCoordinate(completion: MKLocalSearchCompletion?, complete: @escaping (CLLocationCoordinate2D?) -> Void)

    func setCoordinateFromInputHistory(inputHistory: InputHistoryEntity)

    func setCoordinageFromFavoriteInput(favoriteInput: FavoriteInputEntity)

    func setYourLocation(location: CLLocation)

    func setPointName(name: String)

    func sendEditingCellInstance(inputEditingCell: SettingBasePointCell)
}
