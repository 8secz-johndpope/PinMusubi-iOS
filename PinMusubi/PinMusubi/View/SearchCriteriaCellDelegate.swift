//
//  SearchCriteriaCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/22.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Foundation
import UIKit

public protocol SearchCriteriaCellDelegate: AnyObject {
    func scrollUpWithKeyboard(textFieldLimit: CGFloat, keyboardFieldLimit: CGFloat)
}
