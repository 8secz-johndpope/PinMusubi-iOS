//
//  DoneRegisterViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class DoneRegisterViewController: UIViewController {
    @IBOutlet private var closeButton: UIButton!

    public weak var delegate: DoneRegisterViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        closeButton.layer.borderWidth = 1.0
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.cornerRadius = 10
    }

    @IBAction private func didTapCloseButton(_ sender: Any) {
        delegate?.closePresentedView()
    }
}
