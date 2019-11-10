//
//  ContactFormViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit
import WebKit

public class ContactFormViewController: UIViewController {
    @IBOutlet private var webKitView: WKWebView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let formUrl = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScpwEP7UYjRdWcha0OTfm1zdW3TwrslBM2WHw0_BNHybEZ2hA/viewform?usp=sf_link") else { return }
        let request = URLRequest(url: formUrl)
        webKitView.load(request)
    }
}
