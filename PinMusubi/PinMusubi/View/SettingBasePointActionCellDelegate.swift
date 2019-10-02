//
//  SearchCriteriaActionDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/22.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation

public protocol SettingBasePointActionCellDelegate: AnyObject {
    func addSearchCriteriaCell()
    func removeSearchCriteriaCell()
    func doneSetting()
}
