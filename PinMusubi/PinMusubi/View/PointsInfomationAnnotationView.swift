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
public class PointsInfomationAnnotationView: UIView, UITableViewDelegate, UITableViewDataSource {
    /// 地点間の移動時間を表示するTableView
    @IBOutlet private var pointsInfoTableView: UITableView!
    /// 「詳細を見る」のボタンとなるView
    @IBOutlet private var showSpotListButton: UIView!
    /// 設定地点名の一覧
    private var pointNameList = [String]()
    /// 設定地点からピンの地点までの移動時間一覧
    private var transferTimeList = [Int]()
    /// マップ上の地点間の情報を渡すプレゼンター
    private var presenter: PointsInfomationPresenterProrocol?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // プレゼンターの初期化
        self.presenter = PointsInfomationPresenter(view: self, modelType: PointsInfomationModel.self)
        // 詳細を見るボタンの設定
        showSpotListButton.backgroundColor = UIColor(hex: "FA6400")
        showSpotListButton.layer.cornerRadius = 8
        // pointsInfoTabelViewにカスタムセルを設定
        pointsInfoTableView.register(UINib(nibName: "PointInfomationCell", bundle: nil), forCellReuseIdentifier: "PointInfomationCell")
        // delegateの設定
        pointsInfoTableView.delegate = self
        pointsInfoTableView.dataSource = self
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointNameList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PointInfomationCell") as? PointInfomationCell else { return UITableViewCell() }
        cell.setPointInfo(pointName: pointNameList[indexPath.row], transferTime: transferTimeList[indexPath.row])
        return cell
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
}
