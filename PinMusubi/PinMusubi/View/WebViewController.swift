//
//  WebViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import SDWebImage
import UIKit
import WebKit

public class WebViewController: UIViewController {
    @IBOutlet private var chevronLeftButton: UIBarButtonItem!
    @IBOutlet private var chevronRightButton: UIBarButtonItem!
    @IBOutlet private var safariButton: UIBarButtonItem!
    @IBOutlet private var webView: WKWebView!

    private var shop: Shop?

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureButtunItem()
        webView.uiDelegate = self
        webView.navigationDelegate = self

        guard let spotUrl = shop?.urls.pcUrl else { return }
        guard let requestUrl = URL(string: spotUrl) else { return }
        let request = URLRequest(url: requestUrl)
        webView.load(request)
    }

    private func configureButtunItem() {
        if #available(iOS 13.0, *) {
            chevronLeftButton.image = UIImage(systemName: "chevron.left")
            chevronRightButton.image = UIImage(systemName: "chevron.right")
            safariButton.image = UIImage(systemName: "safari")
        } else {
            chevronLeftButton.image = UIImage(named: "ChevronLeft")
            chevronRightButton.image = UIImage(named: "ChevronRight")
            safariButton.image = UIImage(named: "Safari")
        }
        chevronLeftButton.tintColor = UIColor.lightGray
        chevronRightButton.tintColor = UIColor.lightGray
    }

    public func setParameter(shop: Shop) {
        self.shop = shop
    }

    @IBAction private func didTapBackViewButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didTapReloadButton(_ sender: Any) {
        webView.reload()
    }

    @IBAction private func didTapHistoryBackButton(_ sender: Any) {
        webView.goBack()
    }

    @IBAction private func didTappedHistoryForwardButton(_ sender: Any) {
        webView.goForward()
    }

    @IBAction private func didTapActionButton(_ sender: Any) {
        guard let shop = shop else { return }
        let shareText = shop.name
        let shareWebsite = URL(string: shop.urls.pcUrl)

        let activityItems = [shareText, shareWebsite as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

    @IBAction private func didTapSafariButton(_ sender: Any) {
        guard let spotUrl = shop?.urls.pcUrl else { return }
        guard let requestUrl = URL(string: spotUrl) else { return }
        UIApplication.shared.open(requestUrl)
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        if webView.canGoBack {
            chevronLeftButton.tintColor = UIColor.systemBlue
        } else {
            chevronLeftButton.tintColor = UIColor.lightGray
        }
        if webView.canGoForward {
            chevronRightButton.tintColor = UIColor.systemBlue
        } else {
            chevronRightButton.tintColor = UIColor.lightGray
        }
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        title = webView.title
    }
}
