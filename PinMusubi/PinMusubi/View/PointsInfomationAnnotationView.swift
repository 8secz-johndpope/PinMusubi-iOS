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
class PointsInfomationAnnotationView: UIView {
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "\(baseText)(\(Transportation.walk.rawValue))"
        }
    }

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

    @IBOutlet private var transportationButton: UIButton! {
        didSet {
            transportationButton.backgroundColor = UIColor(hex: "26AA52")
            transportationButton.layer.cornerRadius = 8
            transportationButton.layer.shadowOpacity = 0.5
            transportationButton.layer.shadowRadius = 3
            transportationButton.layer.shadowColor = UIColor.lightGray.cgColor
            transportationButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            transportationButton.titleLabel?.font = .systemFont(ofSize: 15.0)
            transportationButton.setTitleColor(.white, for: .normal)
            transportationButton.setTitle("切替", for: .normal)
        }
    }

    private var presenter: PointsInfomationPresenterProrocol?
    private var settingPoints = [SettingPointEntity]()
    private var pinPoint = CLLocationCoordinate2D()
    private var pointInfomationList = [PointInfomationEntity]()
    private var baseText = "各地点からの移動時間"
    private var selectedTransportation = Transportation.walk

    weak var delegate: PointInfomationAnnotationViewDelegate?

    /// 地点情報の設定処理
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    func setPointInfo(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        self.settingPoints = settingPoints
        self.pinPoint = pinPoint

        pointInfomationList = [PointInfomationEntity]()
        pointsInfoTableView.reloadData()

        if presenter == nil {
            presenter = PointsInfomationPresenter(view: self, modelType: PointsInfomationModel.self)
        }

        presenter?.presentPointInfomationList(settingPoints: settingPoints, pinPoint: pinPoint, pointInfomationList: [PointInfomationEntity](), transportation: selectedTransportation)
    }

    func setPointInfomationList(pointInfomationList: [PointInfomationEntity]) {
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

    @IBAction private func didTapTransportationButton(_ sender: Any) {
        switch titleLabel.text {
        case "\(baseText)(\(Transportation.walk.rawValue))":
            titleLabel.text = "\(baseText)(\(Transportation.bicycle.rawValue))"
            selectedTransportation = Transportation.bicycle

        case "\(baseText)(\(Transportation.bicycle.rawValue))" :
            titleLabel.text = "\(baseText)(\(Transportation.car.rawValue))"
            selectedTransportation = Transportation.car

        case "\(baseText)(\(Transportation.car.rawValue))" :
            titleLabel.text = "\(baseText)(\(Transportation.train.rawValue))"
            selectedTransportation = Transportation.train

        case "\(baseText)(\(Transportation.train.rawValue))" :
            titleLabel.text = "\(baseText)(\(Transportation.walk.rawValue))"
            selectedTransportation = Transportation.walk

        case .none:
            titleLabel.text = "\(baseText)(\(Transportation.walk.rawValue))"
            selectedTransportation = Transportation.walk

        case .some(_):
            titleLabel.text = "\(baseText)(\(Transportation.walk.rawValue))"
            selectedTransportation = Transportation.walk
        }

        presenter?.presentPointInfomationList(settingPoints: settingPoints, pinPoint: pinPoint, pointInfomationList: pointInfomationList, transportation: selectedTransportation)
        pointsInfoTableView.reloadData()
    }
}

/// TableViewに関するDelegateメソッド
extension PointsInfomationAnnotationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPoints.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfomationCell") as? PointInfomationCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setPointInfomation(pointName: settingPoints[row].name, row: row)

        if pointInfomationList.isEmpty {
            cell.initPointInfomation()
        } else if pointInfomationList.count > row {
            cell.setTransportationInformation(pointInfomation: pointInfomationList[row])
        }
        cell.replaceTranspotation(transportation: selectedTransportation)

        return cell
    }
}

extension PointsInfomationAnnotationView: PointInfomationCellDelegate {
    func sendInstance(instance: TransportationInfomationViewController) {
        delegate?.showTransportationInfomation(instance: instance)
    }
}
