//
//  SpotListViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class SpotListViewController: UIViewController {
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var favoriteButtonView: UIView!
    @IBOutlet private var collectionView: SpotListCollectionView!
    @IBOutlet private var closeViewButton: UIBarButtonItem!
    private var flowLayout: FlowLayout?
    private var isChangeSegmentedControl: Bool = true
    private var settingPoints: [SettingPointEntity]?
    private var interestPoint: CLLocationCoordinate2D?

    public weak var delegate: SpotListViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        segmentedControl.setTitle("駅・バス停", forSegmentAt: 0)
        segmentedControl.setTitle("飲食店", forSegmentAt: 1)
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor(hex: "FA6400")
        } else {
            segmentedControl.tintColor = UIColor(hex: "FA6400")
        }
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "FA6400")], for: .normal)
        segmentedControl.layer.borderColor = UIColor(hex: "FA6400").cgColor
        segmentedControl.layer.borderWidth = 1.0

        favoriteButtonView.backgroundColor = UIColor(hex: "FA6400")
        favoriteButtonView.layer.cornerRadius = 8

        flowLayout = collectionView.collectionViewLayout as? FlowLayout
        flowLayout?.prepareForPaging()

        collectionView.showsHorizontalScrollIndicator = false
        navigationItem.title = "東京都目黒区下目黒5-4-1下目..."
        closeViewButton.image = UIImage(named: "CloseButton")
    }

    public func setParameter(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) {
        self.settingPoints = settingPoints
        self.interestPoint = interestPoint
    }

    @IBAction private func segmentChanged(sender: AnyObject) {
        isChangeSegmentedControl = false
        let selectedIndex = segmentedControl.selectedSegmentIndex
        flowLayout?.slideView(selectedSegmentIndex: selectedIndex)
    }

    @IBAction private func closeSpotListView(_ sender: Any) {
        delegate?.closeSpotListView()
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
        cell.delegate = self
        if indexPath.row == 0 {
            cell.configre(spotType: .transportation)
        } else if indexPath.row == 1 {
            cell.configre(spotType: .restaurant)
        }
        guard let settingPoints = settingPoints else { return cell }
        guard let interestPoint = interestPoint else { return cell }
        cell.setSpotList(settingPoints: settingPoints, interestPoint: interestPoint)
        return cell
    }
}

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isChangeSegmentedControl = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isChangeSegmentedControl {
            let offSet = scrollView.contentOffset.x
            let collectionWidth = scrollView.bounds.width / 2
            segmentedControl.selectedSegmentIndex = Int(offSet / collectionWidth)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 30)
    }
}

extension SpotListViewController: SpotListCollectionViewCellDelegate {
    public func showSpotDetailsView(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol) {
        let spotDetailsView = UIStoryboard(name: "SpotDetailsView", bundle: nil)
        guard let spotDetailsVC = spotDetailsView.instantiateInitialViewController() as? SpotDetailsViewController else { return }
        spotDetailsVC.configure(settingPoints: settingPoints, spot: spot)
        navigationController?.show(spotDetailsVC, sender: nil)
    }
}
