//
//  WebViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseAnalytics
import SDWebImage
import UIKit
import WebKit

public class WebViewController: UIViewController {
    @IBOutlet private var chevronLeftButton: UIBarButtonItem!
    @IBOutlet private var chevronRightButton: UIBarButtonItem!
    @IBOutlet private var safariButton: UIBarButtonItem!
    @IBOutlet private var webView: WKWebView!

    private var movePageTimes = 0

    private var spot: SpotEntityProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureButtunItem()
        webView.uiDelegate = self
        webView.navigationDelegate = self

        loadWebView()
    }

    private func loadWebView() {
        var spotUrl = ""
        if let shop = spot as? Shop {
            spotUrl = shop.urls.pcUrl
        } else if let hotels = spot as? Hotels {
            guard let hotelInformationURL = hotels.hotel[0].hotelBasicInfo?.hotelInformationURL else { return }
            spotUrl = hotelInformationURL
        } else if let leisure = spot as? Feature {
            guard let searchUrl = ("https://www.google.com/search?q=" + leisure.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            spotUrl = searchUrl
        }
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

    public func setParameter(spot: SpotEntityProtocol) {
        self.spot = spot
    }

    @IBAction private func didTapBackViewButton(_ sender: Any) {
        Analytics.logEvent(
            "close_web_page_of_restaurant",
            parameters: [
                "times_of_move_page": movePageTimes as NSObject
            ]
        )
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
        var shareText = ""
        var spotUrl = ""
        if let shop = spot as? Shop {
            shareText = shop.name
            spotUrl = shop.urls.pcUrl
        } else if let hotels = spot as? Hotels {
            guard let hotelName = hotels.hotel[0].hotelBasicInfo?.hotelName else { return }
            shareText = hotelName
            guard let hotelInformationURL = hotels.hotel[0].hotelBasicInfo?.hotelInformationURL else { return }
            spotUrl = hotelInformationURL
        }
        let shareWebsite = URL(string: spotUrl)
        let activityItems = [shareText, shareWebsite as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

    @IBAction private func didTapSafariButton(_ sender: Any) {
        guard let requestUrl = webView?.url else { return }
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
        movePageTimes += 1
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        title = webView.title
    }
}
