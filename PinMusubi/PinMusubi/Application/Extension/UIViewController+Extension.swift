//
//  UIViewController+Extension.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/07.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureLargeTitle() {
        adjustLargeTitleSize()
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func adjustLargeTitleSize() {
        guard let title = title else { return }

        let maxWidth = UIScreen.main.bounds.size.width - 60
        var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        var width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width

        while width > maxWidth {
            fontSize -= 1
            width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
        }

        navigationController?.navigationBar.largeTitleTextAttributes =
            [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
            ]
    }
}
