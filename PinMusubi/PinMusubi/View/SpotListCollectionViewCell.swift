//
//  SpotListCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

/// スポットの形式
public enum SpotType {
    /// 交通機関
    case transportation
    /// 飲食店
    case restaurant
}

public class SpotListCollectionViewCell: UICollectionViewCell {
    private var spotListScrollView: UIScrollView?
    private var spotListTableView: UITableView?
    private var spotType: SpotType?
    private var spotList = [SpotEntityProtocol]()

    public var restaurantPresenter: RestaurantSpotPresenterProrocol?
    public var stationPresenter: StationSpotPresenterProrocol?
    public var busPresenter: BusStopSpotPresenterProrocol?

    public func configre(spotType: SpotType) {
        self.spotType = spotType
        configrationContent()
    }

    private func configrationContent() {
        spotListScrollView = UIScrollView(frame: bounds)
        guard let spotListScrollView = spotListScrollView else { return }
        addSubview(spotListScrollView)

        spotListTableView = UITableView(frame: bounds, style: .plain)
        guard let spotListTableView = spotListTableView else { return }
        spotListTableView.tableFooterView = UIView(frame: .zero)
        spotListScrollView.addSubview(spotListTableView)

        spotListTableView.delegate = self
        spotListTableView.dataSource = self

        restaurantPresenter = RestaurantSpotPresenter(view: self, modelType: RestaurantSpotsModel.self)
        stationPresenter = StationSpotPresenter(view: self, modelType: StationModel.self)
        busPresenter = BusStopSpotPresenter(view: self, modelType: BusStopModel.self)

        spotListTableView.register(UINib(nibName: "SpotCell", bundle: nil), forCellReuseIdentifier: "SpotCell")
    }

    public func setSpotList(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) {
        if spotType == .transportation {
            stationPresenter?.fetchStationList(interestPoint: interestPoint, completion: { stations in
                self.busPresenter?.fetchBusStopList(interestPoint: interestPoint, stations: stations)
            }
            )
        } else if spotType == .restaurant {
            let orderType = OrderType.byDistance
            restaurantPresenter?.fetchRestaurantSpotList(interestPoint: interestPoint, order: orderType)
        }
    }

    public func setSpotList(spotList: [SpotEntityProtocol]) {
        DispatchQueue.main.async {
            self.spotList = spotList
            self.spotListTableView?.reloadData()
        }
    }
}

extension SpotListCollectionViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: タップしたら詳細画面へ
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
}

extension SpotListCollectionViewCell: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as? SpotCell else { return SpotCell() }
        cell.initialize()
        cell.configure(spot: spotList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
