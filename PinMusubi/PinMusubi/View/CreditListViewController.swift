//
//  CreditListViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class CreditListViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        stackView.removeConstraints(stackView.constraints)
        configureChildren()
    }

    private func configureChildren() {
        var creditVC = CreditViewController()

        addChild(creditVC)
        creditVC.setCreditType(creditType: .recruit)
        stackView.addArrangedSubview(creditVC.view)
        creditVC.didMove(toParent: self)

        creditVC = CreditViewController()
        addChild(creditVC)
        creditVC.setCreditType(creditType: .heartRailsExpress)
        stackView.addArrangedSubview(creditVC.view)
        creditVC.didMove(toParent: self)

        creditVC = CreditViewController()
        addChild(creditVC)
        creditVC.setCreditType(creditType: .busstopapi)
        stackView.addArrangedSubview(creditVC.view)
        creditVC.didMove(toParent: self)

        creditVC = CreditViewController()
        addChild(creditVC)
        creditVC.setCreditType(creditType: .icons8)
        stackView.addArrangedSubview(creditVC.view)
        creditVC.didMove(toParent: self)

        creditVC = CreditViewController()
        addChild(creditVC)
        creditVC.setCreditType(creditType: .pagingCollectionView)
        stackView.addArrangedSubview(creditVC.view)
        creditVC.didMove(toParent: self)
    }
}
