//
//  UIImageView+Extension.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public extension UIImageView {
    /// 画像を非同期で取得
    /// - Parameter url: 画像URL
    /// - Parameter defaultUIImage: 取得に失敗した時の画像
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) {
        if url == nil {
            self.image = defaultUIImage
            return
        }
        DispatchQueue.global().async {
            do {
                guard let url = url else { return }
                let imageData: Data? = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}
