//
//  FavoriteRegisterModalViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import Cosmos
import UIKit

public class FavoriteRegisterModalViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var favoriteTitleTextField: UITextField!
    @IBOutlet private var ratingView: CosmosView!
    @IBOutlet private var favoriteMemoView: UIView!
    @IBOutlet private var favoriteMemoTextView: UITextView!
    private var rating = 0.0
    private var activeTextField: AnyObject?
    private let toolBarHeight: CGFloat = 40
    private let headerHeight: CGFloat = 53

    public weak var delegate: FavoriteRegisterModalViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        favoriteTitleTextField.delegate = self
        favoriteMemoTextView.delegate = self
        scrollView.delegate = self

        configureKeyboard()
        configureNotification()

        ratingView.didFinishTouchingCosmos = { rating in
            self.rating = rating
        }
    }

    private func configureKeyboard() {
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBarHeight)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeButtonTapped))
        tools.items = [spacer, closeButton]
        favoriteMemoTextView.inputAccessoryView = tools
    }

    @IBAction private func didTapCloseButton(_ sender: Any) {
        delegate?.closePresentedView()
    }
    @IBAction private func didTapView(_ sender: Any) {
        view.endEditing(true)
    }

    @objc
    private func closeButtonTapped() {
        view.endEditing(true)
    }
}

extension FavoriteRegisterModalViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension FavoriteRegisterModalViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension FavoriteRegisterModalViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextField = textView
        return true
    }
}

extension FavoriteRegisterModalViewController {
    private func configureNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if activeTextField is UITextView {
            let textLimit = favoriteMemoView.frame.maxY + headerHeight + view.frame.height / 10
            let keyboardLimit = super.view.frame.height - keyboardScreenEndFrame.size.height
            if textLimit >= keyboardLimit {
                scrollView.contentOffset.y = textLimit - keyboardLimit + 10
            }
        }
    }

    @objc
    private func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
    }
}
