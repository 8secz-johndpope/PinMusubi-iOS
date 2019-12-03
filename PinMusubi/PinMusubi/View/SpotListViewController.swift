//
//  SpotListViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/27.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseAnalytics
import GoogleMobileAds
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
    private var spotListAnalyticsEntity: SpotListAnalyticsEntity?

    public weak var delegate: SpotListViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        segmentedControl.setTitle("飲食", forSegmentAt: 0)
        segmentedControl.setTitle("宿泊", forSegmentAt: 1)
        segmentedControl.setTitle("レジャー", forSegmentAt: 2)
        segmentedControl.setTitle("駅・バス停", forSegmentAt: 3)
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

        // Firebase用のパラメータ初期化
        spotListAnalyticsEntity = SpotListAnalyticsEntity()
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
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }

    @IBAction private func closeSpotListView(_ sender: Any) {
        guard let sla = spotListAnalyticsEntity else { return }
        guard let settingPoints = settingPoints else { return }
        let totalSpotNum = sla.numRestaurantSpot + sla.numHotelSpot + sla.numLeisureSpot + sla.numStationSpot
        let totalTapTimes = sla.timesTappedRestaurantSpot + sla.timesTappedHotelSpot + sla.timesTappedLeisureSpot + sla.timesTappedStationSpot
        Analytics.logEvent(
            "close_spot_list_view",
            parameters: [
                "number_of_setting_pin": settingPoints.count as NSObject,
                "total_number_of_spot": totalSpotNum as NSObject,
                "number_of_restaurant_spot": sla.numRestaurantSpot as NSObject,
                "number_of_hotel_spot": sla.numHotelSpot as NSObject,
                "number_of_leisure_spot": sla.numLeisureSpot as NSObject,
                "number_of_station_spot": sla.numStationSpot as NSObject,
                "total_tap_times": totalTapTimes as NSObject,
                "times_of_restaurant_spot": sla.timesTappedRestaurantSpot as NSObject,
                "times_of_hotel_spot": sla.timesTappedHotelSpot as NSObject,
                "times_of_leisure_spot": sla.timesTappedLeisureSpot as NSObject,
                "times_of_station_spot": sla.timesTappedStationSpot as NSObject
            ]
        )
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
            guard let spotListAnalyticsEntity = spotListAnalyticsEntity else { return }
            favoriteRegisterVC.setParameter(settingPoints: settingPoints, interestPoint: interestPoint, spotListAnalyticsEntity: spotListAnalyticsEntity)
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotListCollectionViewCell", for: indexPath)
            as? SpotListCollectionViewCell else { return SpotListCollectionViewCell() }
        cell.delegate = self

        switch indexPath.row {
        case 0:
            cell.configre(spotType: .restaurant)

        case 1:
            cell.configre(spotType: .hotel)

        case 2:
            cell.configre(spotType: .leisure)

        case 3:
            cell.configre(spotType: .transportation)

        default:
            break
        }

        guard let settingPoints = settingPoints else { return cell }
        guard let interestPoint = interestPoint else { return cell }
        cell.setSpotList(settingPoints: settingPoints, interestPoint: interestPoint)
        return cell
    }
}

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let collectionView = scrollView as? UICollectionView
        (collectionView?.collectionViewLayout as? CustomFlowLayout)?.prepareForPaging()
        isChangeSegmentedControl = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isChangeSegmentedControl {
            let offSet = scrollView.contentOffset.x
            let collectionWidth = scrollView.bounds.width + 10
            let centerX = collectionWidth / 2

            if offSet > centerX + collectionWidth * 2 {
                segmentedControl.selectedSegmentIndex = 3
            } else if offSet > centerX + collectionWidth {
                segmentedControl.selectedSegmentIndex = 2
            } else if offSet > centerX {
                segmentedControl.selectedSegmentIndex = 1
            } else if offSet < centerX {
                segmentedControl.selectedSegmentIndex = 0
            }
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

    public func setNumOfSpot(num: Int, spotType: SpotType) {
        switch spotType {
        case .restaurant:
            spotListAnalyticsEntity?.numRestaurantSpot = num

        case .hotel:
            spotListAnalyticsEntity?.numHotelSpot = num

        case .leisure:
            spotListAnalyticsEntity?.numLeisureSpot = num

        case .transportation:
            spotListAnalyticsEntity?.numStationSpot = num
        }
    }

    public func setSpotTypeOfTappedSpot(spotType: SpotType) {
        switch spotType {
        case .restaurant:
            spotListAnalyticsEntity?.timesTappedRestaurantSpot += 1

        case .hotel:
            spotListAnalyticsEntity?.timesTappedHotelSpot += 1

        case .leisure:
            spotListAnalyticsEntity?.timesTappedLeisureSpot += 1

        case .transportation:
            spotListAnalyticsEntity?.timesTappedStationSpot += 1
        }
    }

    public func setRootVC(bannerView: GADBannerView) {
        bannerView.rootViewController = self
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
