//
//  DoneRegisterPresentationController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class DoneRegisterPresentationController: UIPresentationController {
    private var overlayView = UIView()

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        overlayView.frame = containerView.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {[weak self] _ in
            self?.overlayView.alpha = 0.7
            }, completion: nil
        )

        guard let doneRegisterVC = presentedViewController as? DoneRegisterViewController else { return }
        doneRegisterVC.delegate = self
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
        return CGSize(width: parentSize.width * 9 / 10, height: 300)
    }

    override public var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        guard let containerBounds = containerView?.bounds else { return presentedViewFrame }
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = childContentSize.width / 20
        presentedViewFrame.origin.y = UIScreen.main.bounds.size.height / 4

        return presentedViewFrame
    }

    override public func containerViewWillLayoutSubviews() {
        guard let containerViewBounds = containerView?.bounds else { return }
        overlayView.frame = containerViewBounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
    }
}

extension DoneRegisterPresentationController: DoneRegisterViewDelegate {
    public func closePresentedView() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
