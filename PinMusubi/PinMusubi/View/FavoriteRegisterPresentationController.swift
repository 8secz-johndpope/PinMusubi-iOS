//
//  FavoriteRegisterPresentationController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class FavoriteRegisterPresentationController: UIPresentationController {
    private var overlayView = UIView()

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        overlayView.frame = containerView.bounds
        overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTouch(_:)))]
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] _ in
            self?.overlayView.alpha = 0.7
            }, completion: nil
        )

        guard let favoriteRegisterModalVC = presentedViewController as? FavoriteRegisterModalViewController else { return }
        favoriteRegisterModalVC.delegate = self
    }

    override public func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] _ in
            self?.overlayView.alpha = 0.0
            }, completion: nil
        )
    }

    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlayView.removeFromSuperview()
        }
    }

    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }

    override public var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        guard let containerBounds = containerView?.bounds else { return presentedViewFrame }
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = 0.0
        presentedViewFrame.origin.y = childContentSize.height / 10

        return presentedViewFrame
    }

    override public func containerViewWillLayoutSubviews() {
        guard let containerViewBounds = containerView?.bounds else { return }
        overlayView.frame = containerViewBounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }

    @objc
    private func overlayViewDidTouch(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension FavoriteRegisterPresentationController: FavoriteRegisterModalViewDelegate {
    public func closePresentedView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
