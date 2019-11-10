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
    @IBOutlet private var favoriteRegisterLabel: UILabel!
    @IBOutlet private var collectionView: SpotListCollectionView!
    @IBOutlet private var closeViewButton: UIBarButtonItem!
    private var flowLayout: CustomFlowLayout?
    private var isChangeSegmentedControl: Bool = true
    private var settingPoints: [SettingPointEntity]?
    private var interestPoint: CLLocationCoordinate2D?
    private var favoriteButtonViewIsHidden = false

    public weak var delegate: SpotListViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        segmentedControl.setTitle("飲食店", forSegmentAt: 0)
        segmentedControl.setTitle("駅・バス停", forSegmentAt: 1)
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
        favoriteButtonView.layer.borderColor = UIColor(hex: "FA6400").cgColor
        favoriteButtonView.layer.borderWidth = 1.0
        favoriteButtonView.layer.cornerRadius = 8
        favoriteRegisterLabel.adjustsFontSizeToFitWidth = true

        collectionView.showsHorizontalScrollIndicator = false
        closeViewButton.image = UIImage(named: "CloseButton")

        if favoriteButtonViewIsHidden {
            favoriteButtonView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
            favoriteButtonView.layer.borderColor = UIColor(hex: "FA6400", alpha: 0.2).cgColor
        }
    }

    public func setParameter(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D, address: String) {
        self.settingPoints = settingPoints
        self.interestPoint = interestPoint
        navigationItem.title = address
    }

    public func configureFavoriteButton() {
        favoriteButtonViewIsHidden = true
    }

    @IBAction private func segmentChanged(sender: AnyObject) {
        isChangeSegmentedControl = false
        let selectedIndex = segmentedControl.selectedSegmentIndex
        flowLayout?.slideView(selectedSegmentIndex: selectedIndex)
    }

    @IBAction private func closeSpotListView(_ sender: Any) {
        delegate?.closeSpotListView()
    }

    @IBAction private func didTapFavoriteRegisterView(_ sender: Any) {
        if !favoriteButtonViewIsHidden {
            let favoriteRegisterSV = UIStoryboard(name: "FavoriteRegisterModalViewController", bundle: nil)
            guard let favoriteRegisterVC = favoriteRegisterSV.instantiateViewController(withIdentifier: "FavoriteRegisterModalViewController") as? FavoriteRegisterModalViewController else { return }
            favoriteRegisterVC.modalPresentationStyle = .custom
            favoriteRegisterVC.transitioningDelegate = self
            favoriteRegisterVC.doneDelegate = self
            guard let settingPoints = settingPoints else { return }
            guard let interestPoint = interestPoint else { return }
            favoriteRegisterVC.setParameter(settingPoints: settingPoints, interestPoint: interestPoint)
            present(favoriteRegisterVC, animated: true, completion: nil)
        }
    }
}

extension SpotListViewController: UICollectionViewDelegate {}

extension SpotListViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return segmentedControl.numberOfSegments
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        flowLayout = collectionView.collectionViewLayout as? CustomFlowLayout
        flowLayout?.prepareForPaging()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotListCollectionViewCell", for: indexPath)
            as? SpotListCollectionViewCell else { return SpotListCollectionViewCell() }
        cell.delegate = self
        if indexPath.row == 0 {
            cell.configre(spotType: .restaurant)
        } else if indexPath.row == 1 {
            cell.configre(spotType: .transportation)
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
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension SpotListViewController: SpotListCollectionViewCellDelegate {
    public func showSpotDetailsView(settingPoints: [SettingPointEntity], spot: SpotEntityProtocol) {
        let spotDetailsView = UIStoryboard(name: "SpotDetailsView", bundle: nil)
        guard let spotDetailsVC = spotDetailsView.instantiateInitialViewController() as? SpotDetailsViewController else { return }
        spotDetailsVC.setParameter(settingPoints: settingPoints, spot: spot)
        navigationController?.show(spotDetailsVC, sender: nil)
    }
}

extension SpotListViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FavoriteRegisterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension SpotListViewController: FavoriteRegisterModalViewDoneDelegate {
    public func showDoneRegisterView() {
        delegate?.showDoneRegisterView()
    }
}
