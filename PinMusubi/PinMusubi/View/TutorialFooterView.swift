//
//  TutorialFooterView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class TutorialFooterView: UICollectionReusableView {
    @IBOutlet private var closeTutorialViewButton: UIButton! {
        didSet {
            closeTutorialViewButton.layer.cornerRadius = 10
            closeTutorialViewButton.layer.shadowOpacity = 0.5
            closeTutorialViewButton.layer.shadowRadius = 3
            closeTutorialViewButton.layer.shadowColor = UIColor.gray.cgColor
            closeTutorialViewButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }

    public weak var delegate: TutorialFooterDelegate?

    @IBAction private func didTappedCloseTutorialViewButton(_ sender: Any) {
        delegate?.closeTutorialView()
    }
}
