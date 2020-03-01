//
//  PointsInfomationAnnotationView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseAnalytics
import MapKit
import UIKit

/// マップ上の地点間の情報を表示するビュー
internal class PointsInfomationAnnotationView: UIView {
    @IBOutlet private var pointsInfoScrollView: UIScrollView! {
        didSet {
            let screenSize = UIScreen.main.bounds.size
            pointsInfoScrollView.heightAnchor.constraint(equalToConstant: screenSize.height / 5).isActive = true
            pointsInfoScrollView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.8).isActive = true
        }
    }

    @IBOutlet private var pointsInfoTableView: UITableView! {
        didSet {
            pointsInfoTableView.delegate = self
            pointsInfoTableView.dataSource = self
            pointsInfoTableView.register(UINib(nibName: "PointInfomationCell", bundle: nil), forCellReuseIdentifier: "PointInfomationCell")
        }
    }

    @IBOutlet private var showSpotListButton: UIButton! {
        didSet {
            showSpotListButton.backgroundColor = UIColor(hex: "FA6400")
            showSpotListButton.layer.cornerRadius = 8
            showSpotListButton.layer.shadowOpacity = 0.5
            showSpotListButton.layer.shadowRadius = 3
            showSpotListButton.layer.shadowColor = UIColor.lightGray.cgColor
            showSpotListButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            showSpotListButton.setTitle("スポット検索", for: .normal)
            showSpotListButton.titleLabel?.font = .boldSystemFont(ofSize: 15.0)
            showSpotListButton.setTitleColor(.white, for: .normal)
        }
    }

    @IBOutlet private var shareButton: UIButton! {
        didSet {
            shareButton.backgroundColor = UIColor(hex: "4284F4")
            shareButton.layer.cornerRadius = 8
            shareButton.layer.shadowOpacity = 0.5
            shareButton.layer.shadowRadius = 3
            shareButton.layer.shadowColor = UIColor.lightGray.cgColor
            shareButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            shareButton.setTitle("シェアする", for: .normal)
            shareButton.titleLabel?.font = .boldSystemFont(ofSize: 15.0)
            shareButton.setTitleColor(.white, for: .normal)
        }
    }

    @IBOutlet private var transportationSegmentedControl: UISegmentedControl! {
        didSet {
            transportationSegmentedControl.setTitle("車", forSegmentAt: 0)
            transportationSegmentedControl.setTitle("電車", forSegmentAt: 1)
            transportationSegmentedControl.setWidth(50, forSegmentAt: 0)
            transportationSegmentedControl.setWidth(50, forSegmentAt: 1)
            if #available(iOS 13.0, *) {
                transportationSegmentedControl.selectedSegmentTintColor = UIColor(hex: "FA6400")
            } else {
                transportationSegmentedControl.tintColor = UIColor(hex: "FA6400")
            }
            transportationSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            transportationSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "FA6400")], for: .normal)
            transportationSegmentedControl.layer.borderColor = UIColor(hex: "FA6400").cgColor
            transportationSegmentedControl.layer.borderWidth = 1.0
        }
    }

    private var presenter: PointsInfomationPresenterProrocol?
    private var settingPoints = [SettingPointEntity]()
    private var pinPoint = CLLocationCoordinate2D()
    private var pointInfomationList = [PointInfomationEntity]()

    internal weak var delegate: PointInfomationAnnotationViewDelegate?

    /// 地点情報の設定処理
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    internal func setPointInfo(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        self.settingPoints = settingPoints
        self.pinPoint = pinPoint

        pointInfomationList = [PointInfomationEntity]()
        pointsInfoTableView.reloadData()

        presenter = PointsInfomationPresenter(view: self, modelType: PointsInfomationModel.self)
        presenter?.presentPointInfomationList(settingPoints: settingPoints, pinPoint: pinPoint)
    }

    internal func setPointInfomationList(pointInfomationList: [PointInfomationEntity]) {
        self.pointInfomationList = pointInfomationList
        pointsInfoTableView.reloadData()
    }

    @IBAction private func didTapShowSpotListButton(_ sender: Any) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        guard let delegate = delegate else { return }
        delegate.searchSpotList()
    }

    @IBAction private func didTapShareButton(_ sender: Any) {
        Analytics.logEvent("tap_share_button", parameters: [:])
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        let dynamicLinkManager = DynamicLinksManager()
        dynamicLinkManager.createShareLink(settingPoints: settingPoints, pinPoint: pinPoint)
        dynamicLinkManager.createDynamicLink { dynamicLink in
            guard let dynamicLink = dynamicLink else { return }
            let activityItems = [dynamicLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.delegate?.showShareActivity(activityVC: activityVC)
        }
    }

    @IBAction private func didChangeSegmentedControl(_ sender: Any) {
        pointsInfoTableView.reloadData()
    }
}

/// TableViewに関するDelegateメソッド
extension PointsInfomationAnnotationView: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPoints.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfomationCell") as? PointInfomationCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setPointInfomation(pointName: settingPoints[row].name, row: row)
        cell.changeTranspotation(selectedSegmentIndex: transportationSegmentedControl.selectedSegmentIndex)

        if pointInfomationList.isEmpty {
            cell.initPointInfomation()
        } else if pointInfomationList.count > row {
            cell.setTransportationInformation(pointInfomation: pointInfomationList[row])
        }

        return cell
    }
}

extension PointsInfomationAnnotationView: PointInfomationCellDelegate {
    internal func sendWebVCInstance(webVCInstance: WebViewController) {
        delegate?.showTransportationGuideWebPage(webVCInstance: webVCInstance)
    }
}
