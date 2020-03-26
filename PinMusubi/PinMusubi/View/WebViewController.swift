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

class WebViewController: UIViewController {
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

    @IBOutlet private var actionButton: UIBarButtonItem! {
        didSet {
            if #available(iOS 13.0, *) {
                actionButton.image = UIImage(systemName: "square.and.arrow.up")
            } else {
                actionButton.image = UIImage(named: "Action")
            }
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

            var request: URLRequest
            guard let requestURL = spot?.url else { return }
            request = URLRequest(url: requestURL)
            webView.load(request)
            setupProgressView()
        }
    }

    @IBOutlet private var errorView: UIView! {
        didSet {
            errorView.isHidden = true
        }
    }

    private var progressView = UIProgressView(progressViewStyle: .bar)
    private var observeLoading: NSKeyValueObservation?

    private var shareTitle = ""
    private var spot: SpotEntity?

    func setSpot(spot: SpotEntity) {
        self.spot = spot
        shareTitle = spot.name
        title = spot.name
        configureLargeTitle()
    }

    private func setupProgressView() {
        progressView = UIProgressView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 0.0))
        navigationController?.navigationBar.addSubview(progressView)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        observeKeysFowWebView()
    }

    @IBAction private func didTapHistoryBackButton(_ sender: Any) {
        webView.goBack()
    }

    @IBAction private func didTappedHistoryForwardButton(_ sender: Any) {
        webView.goForward()
    }

    @IBAction private func didTapActionButton(_ sender: Any) {
        guard let url = spot?.url else { return }
        let shareWebsite = url
        let activityItems = [shareTitle, shareWebsite as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }

    @IBAction private func didTapSafariButton(_ sender: Any) {
        guard let requestUrl = webView?.url else { return }
        UIApplication.shared.open(requestUrl)
    }

    private func observeKeysFowWebView() {
        observeLoading = webView.observe(\.estimatedProgress, options: [.new], changeHandler: { webView, change in
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(change.newValue!), animated: true)

            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0.3,
                    options: [.curveEaseOut],
                    animations: { [weak self] in
                        self?.progressView.alpha = 0.0
                    }, completion: { _ in
                        self.progressView.setProgress(0.0, animated: false)
                    }
                )
            }
        }
        )
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
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

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        errorView.isHidden = false
    }
}
