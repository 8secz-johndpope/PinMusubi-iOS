//
//  CreditViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class CreditViewController: UIViewController {
    @IBOutlet private var creditTitleLabel: UILabel!
    @IBOutlet private var creditBodyLabel: UILabel!
    private var creditType: CreditType?

    override public func viewDidLoad() {
        super.viewDidLoad()
        guard let creditType = creditType else { return }
        configureCredit(creditType: creditType)
    }

    public func setCreditType(creditType: CreditType) {
        self.creditType = creditType
    }

    private func configureCredit(creditType: CreditType) {
        switch creditType {
        case .recruit:
            creditTitleLabel.text = "ホットペッパーWebサービス"
            let creditBodyText = "This application uses Recruit API. I ackonwledge and am grateful to Recruit teams.\n\nPowered by ホットペッパー Webサービス\nhttp://webservice.recruit.co.jp/"
            let attributedText = NSMutableAttributedString(string: creditBodyText)
            attributedText.addAttribute(
                .link,
                value: "http://webservice.recruit.co.jp/",
                range: NSString(string: creditBodyText).range(of: "ホットペッパー Webサービス")
            )
            creditBodyLabel.attributedText = attributedText

        case .heartRailsExpress:
            creditTitleLabel.text = "HeartRails Express"
            creditBodyLabel.text = "This application uses HeartRails Express API. I ackonwledge and am grateful to HeartRails Express teams.\n\nhttp://express.heartrails.com/api.html"
        case .busstopapi:
            creditTitleLabel.text = "バス停検索API"
            creditBodyLabel.text = "This application uses busstopapi. I ackonwledge and am grateful to busstopapi teams.\n\nhttps://busstopapi.docs.apiary.io"
        case .icons8:
            creditTitleLabel.text = "Icons8"
            creditBodyLabel.text = "This application uses some icon images of Icon8. I ackonwledge and am grateful to Icon8 teams.\n\nhttps://icons8.jp/"
        case .pagingCollectionView:
            creditTitleLabel.text = "PagingCollectionView"
            var creditBodyText = "MIT License\n\nCopyright (c) 2019 nkmrh\n\n"
            creditBodyText += "Permission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\n"
            creditBodyText += "in the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n"
            creditBodyText += "copies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\n"
            creditBodyText += "The above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\n"
            creditBodyText += "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n"
            creditBodyText += "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n"
            creditBodyText += "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n"
            creditBodyText += "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE."
            creditBodyLabel.text = creditBodyText
        }
    }
}

/// クレジットのType
public enum CreditType {
    /// リクルート
    case recruit
    /// 電車
    case heartRailsExpress
    /// バス
    case busstopapi
    /// Icons8
    case icons8
    /// PagingCollectionView
    case pagingCollectionView
}
