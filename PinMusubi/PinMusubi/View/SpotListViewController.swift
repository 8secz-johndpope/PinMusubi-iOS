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

class SpotListViewController: UIViewController {
    @IBOutlet private var segmentedControl: UISegmentedControl! {
        didSet {
            spotTypeList?.forEach {
                guard let index = spotTypeList?.firstIndex(of: $0) else { return }
                segmentedControl.setTitle($0.rawValue, forSegmentAt: index)
            }
            if #available(iOS 13.0, *) {
                segmentedControl.selectedSegmentTintColor = UIColor(hex: "FA6400")
            } else {
                segmentedControl.tintColor = UIColor(hex: "FA6400")
            }
            segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "FA6400")], for: .normal)
            segmentedControl.layer.borderColor = UIColor(hex: "FA6400").cgColor
            segmentedControl.layer.borderWidth = 1.0
        }
    }

    @IBOutlet private var favoriteButtonView: UIView! {
        didSet {
            if !favoriteButtonViewIsHidden {
                favoriteButtonView.backgroundColor = UIColor(hex: "FA6400")
                favoriteButtonView.layer.borderColor = UIColor(hex: "FA6400").cgColor
                favoriteButtonView.layer.shadowOpacity = 0.5
                favoriteButtonView.layer.shadowRadius = 3
                favoriteButtonView.layer.shadowColor = UIColor.gray.cgColor
                favoriteButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
            } else {
                favoriteButtonView.backgroundColor = UIColor(hex: "FA6400", alpha: 0.2)
                favoriteButtonView.layer.borderColor = UIColor(hex: "FA6400", alpha: 0.2).cgColor
            }
            favoriteButtonView.layer.borderWidth = 1.0
            favoriteButtonView.layer.cornerRadius = 8
        }
    }

    @IBOutlet private var favoriteRegisterLabel: UILabel! {
        didSet {
            favoriteRegisterLabel.adjustsFontSizeToFitWidth = true
        }
    }

    @IBOutlet private var collectionView: SpotListCollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }

    @IBOutlet private var closeViewButton: UIBarButtonItem! {
        didSet {
            closeViewButton.image = UIImage(named: "CloseButton")
        }
    }

    private var flowLayout: CustomFlowLayout?
    private var loadingView = LoadingView()
    private var isChangeSegmentedControl: Bool = true
    private var allSpotList: [[SpotEntity]]?
    private var spotTypeList: [SpotType]?
    private var settingPoints: [SettingPointEntity]?
    private var interestPoint: CLLocationCoordinate2D?
    private var favoriteButtonViewIsHidden = false
    private var spotListAnalytics = SpotListAnalyticsEntity()
    private var presenter: SpotListPresenterProtocol?

    public weak var delegate: SpotListViewDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLargeTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func setParameter(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D, address: String) {
        self.settingPoints = settingPoints
        self.interestPoint = interestPoint

        title = address

        presenter = SpotListPresenter(view: self)
        spotTypeList = [.restaurant, .hotel, .leisure, .transportation]
        guard let presenter = presenter, let spotTypeList = spotTypeList else { return }
        presenter.presentAllSpotList(pinPoint: interestPoint, spotTypeList: spotTypeList, region: 3_000)

        configureLoadingView()
    }

    private func configureLoadingView() {
        guard let loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: LoadingView.self, options: nil).first as? LoadingView else { return }
        loadingView.frame = view.bounds
        self.loadingView = loadingView
        view.addSubview(loadingView)
    }

    func setAllSpotList(allSpotList: [[SpotEntity]]) {
        self.allSpotList = allSpotList
        loadingView.removeFromSuperview()
        collectionView.reloadData()
    }

    func configureFavoriteButton() {
        favoriteButtonViewIsHidden = true
    }

    @IBAction private func segmentChanged(sender: AnyObject) {
        isChangeSegmentedControl = false
        let selectedIndex = segmentedControl.selectedSegmentIndex
        flowLayout?.slideView(selectedSegmentIndex: selectedIndex)
    }

    @IBAction private func closeSpotListView(_ sender: Any) {
        guard let settingPoints = settingPoints else { return }
        let totalSpotNum = spotListAnalytics.numRestaurantSpot + spotListAnalytics.numHotelSpot + spotListAnalytics.numLeisureSpot + spotListAnalytics.numStationSpot
        let totalTapTimes = spotListAnalytics.timesTappedRestaurantSpot + spotListAnalytics.timesTappedHotelSpot + spotListAnalytics.timesTappedLeisureSpot + spotListAnalytics.timesTappedStationSpot
        Analytics.logEvent(
            "close_spot_list_view",
            parameters: [
                "number_of_setting_pin": settingPoints.count as NSObject,
                "total_number_of_spot": totalSpotNum as NSObject,
                "number_of_restaurant_spot": spotListAnalytics.numRestaurantSpot as NSObject,
                "number_of_hotel_spot": spotListAnalytics.numHotelSpot as NSObject,
                "number_of_leisure_spot": spotListAnalytics.numLeisureSpot as NSObject,
                "number_of_station_spot": spotListAnalytics.numStationSpot as NSObject,
                "total_tap_times": totalTapTimes as NSObject,
                "times_of_restaurant_spot": spotListAnalytics.timesTappedRestaurantSpot as NSObject,
                "times_of_hotel_spot": spotListAnalytics.timesTappedHotelSpot as NSObject,
                "times_of_leisure_spot": spotListAnalytics.timesTappedLeisureSpot as NSObject,
                "times_of_station_spot": spotListAnalytics.timesTappedStationSpot as NSObject
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
            favoriteRegisterVC.setParameter(settingPoints: settingPoints, interestPoint: interestPoint, spotListAnalyticsEntity: spotListAnalytics)
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            present(favoriteRegisterVC, animated: true, completion: nil)
        }
    }
}

extension SpotListViewController: UICollectionViewDelegate {}

extension SpotListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return segmentedControl.numberOfSegments
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        flowLayout = collectionView.collectionViewLayout as? CustomFlowLayout
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotListCollectionViewCell", for: indexPath)
            as? SpotListCollectionViewCell else { return SpotListCollectionViewCell() }
        cell.delegate = self

        if let settingPoints = settingPoints, let spotType = spotTypeList?[indexPath.row], let allSpotList = allSpotList {
            cell.setSpotList(settingPoints: settingPoints, spotType: spotType, spotList: allSpotList[indexPath.row])
        }
        return cell
    }
}

extension SpotListViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let collectionView = scrollView as? UICollectionView
        (collectionView?.collectionViewLayout as? CustomFlowLayout)?.prepareForPaging()
        isChangeSegmentedControl = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension SpotListViewController: SpotListCollectionViewCellDelegate {
    func showSpotDetailsView(settingPoints: [SettingPointEntity], spot: SpotEntity) {
        let spotDetail = UIStoryboard(name: "SpotDetailViewController", bundle: nil)
        guard let spotDetailVC = spotDetail.instantiateInitialViewController() as? SpotDetailViewController else { return }
        spotDetailVC.setup(spot: spot)
        navigationController?.show(spotDetailVC, sender: nil)
    }

    public func setNumOfSpot(num: Int, spotType: SpotType) {
        switch spotType {
        case .restaurant:
            spotListAnalytics.numRestaurantSpot = num

        case .hotel:
            spotListAnalytics.numHotelSpot = num

        case .leisure:
            spotListAnalytics.numLeisureSpot = num

        case .transportation:
            spotListAnalytics.numStationSpot = num
        }
    }

    public func setSpotTypeOfTappedSpot(spotType: SpotType) {
        switch spotType {
        case .restaurant:
            spotListAnalytics.timesTappedRestaurantSpot += 1

        case .hotel:
            spotListAnalytics.timesTappedHotelSpot += 1

        case .leisure:
            spotListAnalytics.timesTappedLeisureSpot += 1

        case .transportation:
            spotListAnalytics.timesTappedStationSpot += 1
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

/// スポットの形式
public enum SpotType: String {
    case restaurant = "飲食"
    case hotel = "宿泊"
    case leisure = "レジャー"
    case transportation = "交通機関"
}
