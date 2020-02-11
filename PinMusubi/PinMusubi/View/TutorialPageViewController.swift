//
//  TutorialPageViewController.swift
//  BackGroundVideoSample
//
//  Created by rMac on 2020/02/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

internal class TutorialPageViewController: UIPageViewController {
    private var pageControl: UIPageControl?
    private var tutorialVCs: [TutorialViewController] = []
    private let pages: [PageType] = PageType.allCases

    override internal func viewDidLoad() {
        super.viewDidLoad()

        configurePageControl()
        configurePageController()
    }

    private func configurePageController() {
        tutorialVCs = pages.map {
            TutorialViewController(pageType: $0)
        }
        setViewControllers([tutorialVCs[0]], direction: .forward, animated: false, completion: nil)
        dataSource = self
    }

    private func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        guard let pageControl = pageControl else { return }
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
    }
}

extension TutorialPageViewController: UIPageViewControllerDataSource {
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let tutorialVC = viewController as? TutorialViewController else { return nil }
        guard let pageControl = pageControl else { return nil }
        if let index = tutorialVCs.firstIndex(of: tutorialVC), index > 0 {
            pageControl.currentPage = index
            return tutorialVCs[index - 1]
        } else {
            pageControl.currentPage = 0
            return nil
        }
    }

    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let tutorialVC = viewController as? TutorialViewController else { return nil }
        guard let pageControl = pageControl else { return nil }
        if let index = tutorialVCs.firstIndex(of: tutorialVC), index < tutorialVCs.count - 1 {
            pageControl.currentPage = index
            return tutorialVCs[index + 1]
        } else {
            pageControl.currentPage = tutorialVCs.count
            return nil
        }
    }

    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return tutorialVCs.count
    }
}
