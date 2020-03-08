//
//  TransportationInfomationViewController.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/08.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit
import WebKit

class TransportationInfomationViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.adjustsFontSizeToFitWidth = true

        guard let requestUrl = URL(string: requestUrlString) else { return }
        webView.load(URLRequest(url: requestUrl))
    }

    private var requestUrlString = ""
    private var titleText = ""

    func setTransportationGuideInfo(urlString: String, fromStation: String, toStation: String) {
        requestUrlString = urlString
        titleText = "\(fromStation)駅から\(toStation)駅までの乗換案内"
    }

    @IBAction private func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
