//
//  CustomFloatingPanelLayout.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FloatingPanel
import UIKit

public class CustomFloatingPanelLayout: FloatingPanelLayout {
    // 初期位置
    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    // positionごとのサイズ設定
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0 // A top inset from safe area
        case .half: return 220.0 // A bottom inset from the safe area
        case .tip: return 60.0 // A bottom inset from the safe area
        default: return nil
        }
    }
}