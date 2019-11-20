//
//  LoadingView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import SwiftyGif
import UIKit

public class LoadingView: UIView {
    @IBOutlet private var loadingImageView: UIImageView!
    @IBOutlet private var loadingView: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        loadingImageView.isHidden = true
        loadGifImage()
    }

    private func loadGifImage() {
        do {
            let gif = try UIImage(gifName: "loading.gif")
            let imageView = UIImageView(gifImage: gif, loopCount: -1)
            imageView.frame = loadingView.bounds
            loadingView.addSubview(imageView)
        } catch {
            print(error)
            loadingView.isHidden = true
        }
    }
}
