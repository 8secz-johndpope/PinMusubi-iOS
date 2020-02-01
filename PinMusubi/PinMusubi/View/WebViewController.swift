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
    @IBOutlet private var chevronLeftButton: UIBarButtonItem! {
        didSet {
            if #available(iOS 13.0, *) {
                chevronLeftButton.image = UIImage(systemName: "chevron.left")
            } else {
                chevronLeftButton.image = UIImage(named: "ChevronLeft")
            }
            chevronLeftButton.tintColor = UIColor.lightGray
        }
    }

    @IBOutlet private var chevronRightButton: UIBarButtonItem! {
        didSet {
            if #available(iOS 13.0, *) {
                chevronRightButton.image = UIImage(systemName: "chevron.right")
            } else {
                chevronRightButton.image = UIImage(named: "ChevronRight")
            }
            chevronRightButton.tintColor = UIColor.lightGray
        }
    }

    @IBOutlet private var safariButton: UIBarButtonItem! {
        didSet {
            if #available(iOS 13.0, *) {
                safariButton.image = UIImage(systemName: "safari")
            } else {
                safariButton.image = UIImage(named: "Safari")
            }
        }
    }

    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.navigationDelegate = self

            guard let requestUrl = URL(string: requestUrlString) else { return }
            let request = URLRequest(url: requestUrl)
            webView.load(request)
        }
    }

    private var requestUrlString = ""
    private var shareTitle = ""
    private var spot: SpotEntityProtocol?
    private var movePageTimes = 0

    public func setSpot(spot: SpotEntityProtocol) {
        self.spot = spot
        if let shop = spot as? Shop {
            guard let affiliateURLString = KeyManager().getValue(key: "HOT PEPPER Affiliate URL") as? String else { return }
            requestUrlString = affiliateURLString + shop.urls.pcUrl
            shareTitle = shop.name
        } else if let hotels = spot as? Hotels {
            guard let hotelInformationURL = hotels.hotel[0].hotelBasicInfo?.hotelInformationURL else { return }
            requestUrlString = hotelInformationURL
            guard let hotelName = hotels.hotel[0].hotelBasicInfo?.hotelName else { return }
            shareTitle = hotelName
        } else if let leisure = spot as? Feature {
            guard let searchUrl = ("https://www.google.com/search?q=" + leisure.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            requestUrlString = searchUrl
            shareTitle = leisure.name
        }
    }

    public func setTransportationGuideInfo(urlString: String, fromStation: String, toStation: String) {
        requestUrlString = urlString
        shareTitle = "\(fromStation)駅から\(toStation)駅までの乗換案内"
    }

    @IBAction private func didTapBackViewButton(_ sender: Any) {
        var eventQuery = ""

        switch spot {
        case is Shop:
            eventQuery = "restaurant"
        case is Hotels:
            eventQuery = "hotel"
        case is Feature:
            eventQuery = "leisure"
        default:
            break
        }

        Analytics.logEvent(
            "close_web_page_of_" + eventQuery,
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
        let shareWebsite = URL(string: requestUrlString)
        let activityItems = [shareTitle, shareWebsite as Any] as [Any]
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
