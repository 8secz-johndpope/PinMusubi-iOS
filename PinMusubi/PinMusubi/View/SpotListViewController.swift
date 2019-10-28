//
//  SpotListViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotListViewController: UIViewController {
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var favoriteButtonView: UIView!
    @IBOutlet private var collectionView: SpotListCollectionView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        segmentedControl.setTitle("駅・バス停", forSegmentAt: 0)
        segmentedControl.setTitle("飲食店", forSegmentAt: 1)
        segmentedControl.backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor(hex: "FA6400")
        } else {
            segmentedControl.tintColor = UIColor(hex: "FA6400")
        }
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

        favoriteButtonView.backgroundColor = UIColor(hex: "FA6400")
        favoriteButtonView.layer.cornerRadius = 8

        self.navigationItem.title = "東京都目黒区下目黒5-4-1下目..."
    }
}

extension SpotListViewController: UICollectionViewDelegate {}

extension SpotListViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return segmentedControl.numberOfSegments
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotListCollectionViewCell", for: indexPath)
            as? SpotListCollectionViewCell else { return SpotListCollectionViewCell() }
        if indexPath.row == 0 {
            cell.configre(spotType: .transportation, collectionViewSize: collectionView.bounds.size)
        } else if indexPath.row == 1 {
            cell.configre(spotType: .restaurant, collectionViewSize: collectionView.bounds.size)
        }
        return cell
    }
}

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        (collectionView.collectionViewLayout as? FlowLayout)?.prepareForPaging()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
