//
//  MKLocalSearchCategory.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/24.
//  Copyright © 2020 naipaka. All rights reserved.
//

protocol MKLocalSearchCategory: CaseIterable {
    func getSearchName() -> String
    func getDisplayName() -> String
}
