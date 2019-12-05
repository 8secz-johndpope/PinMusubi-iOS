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
    /// 地点間の移動距離を表示するScrollView
    @IBOutlet private var pointsInfoScrollView: UIScrollView!
    /// 地点間の移動時間を表示するTableView
    @IBOutlet private var pointsInfoTableView: UITableView!
    /// 「詳細を見る」のボタンとなるView
    @IBOutlet private var showSpotListButton: UIView!
    /// 交通手段のSegmentedControl
    @IBOutlet private var transportationSegmentedControl: UISegmentedControl!
    /// 設定地点名の一覧
    private var pointNameList = [String]()
    /// 設定地点からピンの地点までの移動時間一覧
    private var transferTimeList = [Int]()
    /// マップ上の地点間の情報を渡すプレゼンター
    private var presenter: PointsInfomationPresenterProrocol?

    public weak var delegate: PointInfomationAnnotationViewDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // delegateの設定
        pointsInfoTableView.delegate = self
        pointsInfoTableView.dataSource = self
        // プレゼンターの初期化
        presenter = PointsInfomationPresenter(view: self, modelType: PointsInfomationModel.self)
        // pointsInfoTabelViewにカスタムセルを設定
        pointsInfoTableView.register(UINib(nibName: "PointInfomationCell", bundle: nil), forCellReuseIdentifier: "PointInfomationCell")

        configureUI()
        setGesture()
    }

    /// 地点情報の設定処理
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter pinPoint: ピンの地点の座標
    public func setPointInfo(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        presenter?.getPointsInfomation(settingPoints: settingPoints, pinPoint: pinPoint)
    }

    /// 地点間の移動時間を表示するTableViewの再読み込み処理
    /// - Parameter pointNameList: 地点名の一覧
    /// - Parameter transferTimeList: 移動時間一覧
    public func reloadPointsInfoTableView(pointNameList: [String], transferTimeList: [Int]) {
        self.pointNameList = pointNameList
        self.transferTimeList = transferTimeList
        pointsInfoTableView.reloadData()
    }

    @IBAction private func tappedShowSpotListButton(_ sender: UITapGestureRecognizer) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        guard let delegate = delegate else { return }
        delegate.searchSpotList()
    }

    private func setGesture() {
        let tapShowSpotListButton = UITapGestureRecognizer(target: self, action: #selector(self.tappedShowSpotListButton(_:)))
        showSpotListButton.addGestureRecognizer(tapShowSpotListButton)
    }

    public func configureUI() {
        let screenSize = UIScreen.main.bounds.size
        pointsInfoScrollView.heightAnchor.constraint(equalToConstant: screenSize.height / 7).isActive = true
        showSpotListButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.8).isActive = true

        showSpotListButton.backgroundColor = UIColor(hex: "FA6400")
        showSpotListButton.layer.cornerRadius = 8

        // 交通手段のSegmentedControlの設定
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

    @IBAction private func didChangeSegmentedControl(_ sender: Any) {
        pointsInfoTableView.reloadData()
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
}

/// TableViewに関するDelegateメソッド
extension PointsInfomationAnnotationView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointNameList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfomationCell") as? PointInfomationCell else { return UITableViewCell() }
        cell.setPointInfo(pointName: pointNameList[indexPath.row], transferTime: transferTimeList[indexPath.row])
        cell.setPinImage(row: indexPath.row)
        cell.changeTranspotation(selectedSegmentIndex: transportationSegmentedControl.selectedSegmentIndex)
        return cell
    }
}
