//
//  VersionInfoViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/15.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class VersionInfoViewController: UIViewController {
    @IBOutlet private var versionInfoView: UIView! {
        didSet {
            versionInfoView.layer.cornerRadius = 10
            versionInfoView.layer.borderWidth = 0.5
        }
    }

    @IBOutlet private var latestVersionLabel: UILabel! {
        didSet {
            guard let latestVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return }
            latestVersionLabel.text = latestVersion
        }
    }

    @IBOutlet private var versionInfoTextView: UITextView! {
        didSet {
            guard let versionInfo = KeyManager().getValue(key: "Version Info") as? String else { return }
            versionInfoTextView.text = versionInfo
            versionInfoTextView.isEditable = false
        }
    }

    @IBOutlet private var bottonsView: UIView! {
        didSet {
            bottonsView.layer.cornerRadius = 10
            bottonsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            bottonsView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            bottonsView.layer.shadowColor = UIColor.black.cgColor
            bottonsView.layer.shadowOpacity = 0.6
            bottonsView.layer.shadowRadius = 4
        }
    }

    @IBOutlet private var showReviewPageViewButton: UIButton! {
        didSet {
            showReviewPageViewButton.backgroundColor = UIColor(hex: "FA6400")
            showReviewPageViewButton.layer.cornerRadius = 8
            showReviewPageViewButton.tintColor = .white
        }
    }

    @IBOutlet private var closeVersionInfoViewButton: UIButton! {
        didSet {
            closeVersionInfoViewButton.layer.borderColor = UIColor(hex: "FA6400").cgColor
            closeVersionInfoViewButton.layer.borderWidth = 1.0
            closeVersionInfoViewButton.layer.cornerRadius = 8
            closeVersionInfoViewButton.tintColor = UIColor(hex: "FA6400")
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }

    override public func viewDidLayoutSubviews() {
        versionInfoTextView.setContentOffset(CGPoint(x: 0, y: -versionInfoTextView.contentInset.top), animated: false)
    }

    @IBAction private func showReviewPage(_ sender: Any) {
        guard let reviewUrl = URL(string: "https://itunes.apple.com/app/id1489074206?action=write-review") else { return }
        UIApplication.shared.open(reviewUrl)
    }

    @IBAction private func closeVersionInfo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
