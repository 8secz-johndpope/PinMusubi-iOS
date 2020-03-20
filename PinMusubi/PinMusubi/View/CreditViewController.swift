//
//  CreditViewController.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

import Foundation
import UIKit

class CreditViewController: UIViewController {
    @IBOutlet private var textView: UITextView!

    private var baseString = ""

    private var hotpepperURL = URL(string: "http://webservice.recruit.co.jp/")
    private var rakutenURL = URL(string: "https://webservice.rakuten.co.jp/")
    private var yahooURL = URL(string: "https://developer.yahoo.co.jp/sitemap/index.html")
    private var ekispertURL = URL(string: "http://docs.ekispert.com/v1/le/")
    private var icons8URL = URL(string: "https://icons8.jp/icons")

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        title = "クレジット一覧"
        baseString = textView.text
        textView.attributedText = setAttributedString(baseString: baseString)
    }

    private func setAttributedString(baseString: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: baseString)

        // 文字の設定
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "Hotpepper Web Service")
        )

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "Rakuten Web Service")
        )

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "Yahoo! JAPAN Web Service")
        )

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "Ekispert Web Service")
        )

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "Icons8")
        )

        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSString(string: baseString).range(of: "PagingCollectionView")
        )

        // リンクの設定
        attributedString.addAttribute(
            .link,
            value: "HotpepperLink",
            range: NSString(string: baseString).range(of: "ホットペッパー Webサービス")
        )

        attributedString.addAttribute(
            .link,
            value: "RakutenLink",
            range: NSString(string: baseString).range(of: "Supported by Rakuten Developers")
        )

        attributedString.addAttribute(
            .link,
            value: "YahooLink",
            range: NSString(string: baseString).range(of: "Web Services by Yahoo! JAPAN")
        )

        attributedString.addAttribute(
            .link,
            value: "EkispertLink",
            range: NSString(string: baseString).range(of: "駅すぱあとWebサービス")
        )

        attributedString.addAttribute(
            .link,
            value: "icons8Link",
            range: NSString(string: baseString).range(of: "https://icon8.jp/")
        )

        return attributedString
    }
}

extension CreditViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
        case "HotpepperLink":
            if UIApplication.shared.canOpenURL(hotpepperURL!) {
                UIApplication.shared.open(hotpepperURL!)
            }
            return true

        case "RakutenLink":
            if UIApplication.shared.canOpenURL(rakutenURL!) {
                UIApplication.shared.open(rakutenURL!)
            }
            return true

        case "YahooLink":
            if UIApplication.shared.canOpenURL(yahooURL!) {
                UIApplication.shared.open(yahooURL!)
            }
            return true

        case "EkispertLink":
            if UIApplication.shared.canOpenURL(ekispertURL!) {
                UIApplication.shared.open(ekispertURL!)
            }
            return true

        case "icons8Link":
            if UIApplication.shared.canOpenURL(icons8URL!) {
                UIApplication.shared.open(icons8URL!)
            }
            return true

        default:
            return false
        }
    }
}
