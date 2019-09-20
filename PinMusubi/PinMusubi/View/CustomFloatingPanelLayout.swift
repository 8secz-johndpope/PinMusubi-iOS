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

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0 // A top inset from safe area
        case .half: return 180.0 // A bottom inset from the safe area
        case .tip: return 60.0 // A bottom inset from the safe area
        default: return nil
        }
    }

    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291)
            ]
        } else {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291)
            ]
        }
    }
}
