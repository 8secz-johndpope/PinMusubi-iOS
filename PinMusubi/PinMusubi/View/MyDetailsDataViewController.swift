//
//  MyDetailsDataViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseAnalytics
import MapKit
import UIKit

public class MyDetailsDataViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView! {
        didSet {
            stackView.removeConstraints(stackView.constraints)
        }
    }

    private var spotListNC: SpotListNavigationController?
    private var headerVC: MyDetailsDataHeaderViewController?
    private var myData: MyDataEntityProtocol?

    public var presenter: MyDetailsDataPresenterProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()

        presenter = MyDetailsDataPresenter(vc: self, modelType: SearchInterestPlaceModel.self)

        configureChildren()
        configureNavigationBar()
    }

    public func setParameter(myData: MyDataEntityProtocol) {
        self.myData = myData
    }

    private func configureNavigationBar() {
        if let favoriteData = myData as? FavoriteSpotEntity {
            let interestPoint = CLLocationCoordinate2D(latitude: favoriteData.latitude, longitude: favoriteData.longitude)
            presenter?.getAddress(interestPoint: interestPoint, complete: { address in
                self.navigationItem.title = address
            }
            )
        }
    }

    private func configureChildren() {
        guard let favoriteData = myData as? FavoriteSpotEntity else { return }
        // Header
        headerVC = MyDetailsDataHeaderViewController()
        headerVC?.getFavoriteData(id: favoriteData.id)
        addChild(headerVC ?? MyDetailsDataHeaderViewController())
        stackView.addArrangedSubview(headerVC?.view ?? MyDetailsDataHeaderViewController().view)
        headerVC?.didMove(toParent: self)
        // MyDetailsDataAction
        let myDetailsDataActionVC = MyDetailsDataActionViewController()
        myDetailsDataActionVC.delegate = self
        addChild(myDetailsDataActionVC)
        stackView.addArrangedSubview(myDetailsDataActionVC.view)
        // TravelTimePanel
        let travelTimePanelVC = TravelTimePanelViewController()
        travelTimePanelVC.setParameter(myData: favoriteData)
        addChild(travelTimePanelVC)
        stackView.addArrangedSubview(travelTimePanelVC.view)
        travelTimePanelVC.didMove(toParent: self)
        myDetailsDataActionVC.didMove(toParent: self)
    }

    @IBAction private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func ditSwipeView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didTapMenuButton(_ sender: Any) {
        let actionMenu = UIAlertController()
        let editAction = UIAlertAction(title: "スポットを編集する", style: .default, handler: { (_: UIAlertAction) -> Void in
            self.presentUpdateView()
        }
        )
        let deleteAction = UIAlertAction(title: "スポットを削除する", style: .destructive, handler: { (_: UIAlertAction) -> Void in
            let deleteConfirmAlert = UIAlertController(title: nil, message: "本当に削除してよろしいですか？", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "削除", style: .destructive, handler: { (_: UIAlertAction) -> Void in
                self.deleteFavoriteData()
            }
            )
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            deleteConfirmAlert.addAction(deleteAction)
            deleteConfirmAlert.addAction(cancelAction)
            self.present(deleteConfirmAlert, animated: true, completion: nil)
        }
        )
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        actionMenu.addAction(editAction)
        actionMenu.addAction(deleteAction)
        actionMenu.addAction(cancelAction)
        present(actionMenu, animated: true, completion: nil)
    }

    private func presentUpdateView() {
        let favoriteRegisterModalSV = UIStoryboard(name: "FavoriteRegisterModalViewController", bundle: nil)
        guard let favoriteRegisterModalVC = favoriteRegisterModalSV.instantiateInitialViewController() as? FavoriteRegisterModalViewController else { return }
        guard let favoriteData = self.myData as? FavoriteSpotEntity else { return }
        favoriteRegisterModalVC.setEditParameter(favoriteId: favoriteData.id)
        favoriteRegisterModalVC.delegate = self
        self.present(favoriteRegisterModalVC, animated: true, completion: nil)
    }

    private func deleteFavoriteData() {
        let model = MyDataModel()
        guard let favoriteData = myData as? FavoriteSpotEntity else { return }
        if model.deleteFavoriteData(id: favoriteData.id) {
            navigationController?.popViewController(animated: true)
        }
        model.deleteDocument(id: favoriteData.id)
    }
}

extension MyDetailsDataViewController: FavoriteRegisterModalViewDelegate {
    public func closePresentedView() {
        guard let favoriteData = myData as? FavoriteSpotEntity else { return }
        headerVC?.getFavoriteData(id: favoriteData.id)
        headerVC?.viewDidLoad()
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension MyDetailsDataViewController: MyDetailsDataActionViewDelegate {
    public func moveFromMyPage(viewType: ViewType) {
        guard let myData = myData else { return }
        if viewType == .map {
            showSettingPointsOnMap(myData: myData)
        } else if viewType == .spotList {
            showSpotList(myData: myData)
        }
    }

    private func showSettingPointsOnMap(myData: MyDataEntityProtocol) {
        guard let searchInterestPlaceVC = tabBarController?.viewControllers?[1] as? SearchInterestPlaceViewController else { return }
        NotificationCenter.default.post(name: Notification.doneSettingNotification, object: nil)
        if let favoriteData = myData as? FavoriteSpotEntity {
            // Firebaseのイベント送信
            Analytics.logEvent(
                "show_setting_points_on_map_from_favorite",
                parameters: [:]
            )

            var settingPoints = [SettingPointEntity]()
            for settingPoint in favoriteData.settingPointEntityList {
                settingPoints.append(settingPoint)
            }
            let favoritePoint = CLLocationCoordinate2D(latitude: favoriteData.latitude, longitude: favoriteData.longitude)

            searchInterestPlaceVC.setPin(settingPoints: settingPoints, halfwayPoint: favoritePoint)
        } else if let historyData = myData as? SearchHistoryEntity {
            // Firebaseのイベント送信
            Analytics.logEvent(
                "show_setting_points_on_map_from_history",
                parameters: [:]
            )

            var settingPoints = [SettingPointEntity]()
            for settingPoint in historyData.settingPointEntityList {
                settingPoints.append(settingPoint)
            }
            let historyPoint = CLLocationCoordinate2D(latitude: historyData.halfwayPointLatitude, longitude: historyData.halfwayPointLongitude)
            searchInterestPlaceVC.setPin(settingPoints: settingPoints, halfwayPoint: historyPoint)
        }
        tabBarController?.selectedViewController = searchInterestPlaceVC
    }

    private func showSpotList(myData: MyDataEntityProtocol) {
        if let favoriteData = myData as? FavoriteSpotEntity {
            // Firebaseのイベント送信
            Analytics.logEvent(
                "show_spot_list_from_favorite",
                parameters: [:]
            )

            let model = SearchInterestPlaceModel()
            let favoritePoint = CLLocationCoordinate2D(latitude: favoriteData.latitude, longitude: favoriteData.longitude)
            model.getAddress(point: favoritePoint, complete: { address, status in
                if status == .success {
                    let spotListSV = UIStoryboard(name: "SpotListViewController", bundle: nil)
                    self.spotListNC = spotListSV.instantiateInitialViewController() as? SpotListNavigationController
                    guard let spotListNC = self.spotListNC else { return }
                    guard let spotListVC = spotListNC.topViewController as? SpotListViewController else { return }
                    spotListVC.delegate = self

                    var settingPoints = [SettingPointEntity]()
                    for settingPoint in favoriteData.settingPointEntityList {
                        settingPoints.append(settingPoint)
                    }
                    spotListVC.setParameter(settingPoints: settingPoints, interestPoint: favoritePoint, address: address)
                    self.present(spotListNC, animated: true, completion: nil)
                    spotListVC.configureFavoriteButton()
                }
            }
            )
        }
    }
}

extension MyDetailsDataViewController: SpotListViewDelegate {
    public func closeSpotListView() {
        spotListNC?.dismiss(animated: true, completion: nil)
    }

    public func showDoneRegisterView() {}
}
