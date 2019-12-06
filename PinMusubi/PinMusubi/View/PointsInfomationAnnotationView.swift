//
//  PointsInfomationAnnotationView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/23.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

/// マップ上の地点間の情報を表示するビュー
public class PointsInfomationAnnotationView: UIView {
    @IBOutlet private var pointsInfoScrollView: UIScrollView! {
        didSet {
            let screenSize = UIScreen.main.bounds.size
            pointsInfoScrollView.heightAnchor.constraint(equalToConstant: screenSize.height / 5).isActive = true
        }
    }

    @IBOutlet private var pointsInfoTableView: UITableView! {
        didSet {
            pointsInfoTableView.delegate = self
            pointsInfoTableView.dataSource = self
            pointsInfoTableView.register(UINib(nibName: "PointInfomationCell", bundle: nil), forCellReuseIdentifier: "PointInfomationCell")
        }
    }

    @IBOutlet private var showSpotListButton: UIView! {
        didSet {
            let screenSize = UIScreen.main.bounds.size
            showSpotListButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.8).isActive = true
            showSpotListButton.backgroundColor = UIColor(hex: "FA6400")
            showSpotListButton.layer.cornerRadius = 8
            showSpotListButton.layer.shadowOpacity = 0.5
            showSpotListButton.layer.shadowRadius = 3
            showSpotListButton.layer.shadowColor = UIColor.lightGray.cgColor
            showSpotListButton.layer.shadowOffset = CGSize(width: 3, height: 3)

            let tapShowSpotListButton = UITapGestureRecognizer(target: self, action: #selector(self.tappedShowSpotListButton(_:)))
            showSpotListButton.addGestureRecognizer(tapShowSpotListButton)
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

    private var settingPoints = [SettingPointEntity]()
    private var pinPoint = CLLocationCoordinate2D()

    public weak var delegate: PointInfomationAnnotationViewDelegate?

    /// 地点情報の設定処理
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func setPointInfo(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        self.settingPoints = settingPoints
        self.pinPoint = pinPoint
        pointsInfoTableView.reloadData()
    }

    @IBAction private func tappedShowSpotListButton(_ sender: UITapGestureRecognizer) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        guard let delegate = delegate else { return }
        delegate.searchSpotList()
    }

    @IBAction private func didChangeSegmentedControl(_ sender: Any) {
        pointsInfoTableView.reloadData()
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
}

/// TableViewに関するDelegateメソッド
extension PointsInfomationAnnotationView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPoints.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfomationCell") as? PointInfomationCell else { return UITableViewCell() }
        cell.setPointInfo(settingPoint: settingPoints[indexPath.row], pinPoint: pinPoint, row: indexPath.row)
        cell.setPinImage(row: indexPath.row)
        cell.changeTranspotation(selectedSegmentIndex: transportationSegmentedControl.selectedSegmentIndex)
        cell.delegate = self
        return cell
    }
}

extension PointsInfomationAnnotationView: PointInfomationCellDelegate {
    public func sendWebVCInstance(webVCInstance: WebViewController) {
        delegate?.showTransportationGuideWebPage(webVCInstance: webVCInstance)
    }
}
