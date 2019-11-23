//
//  SpotListCollectionViewCell.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds
import MapKit
import UIKit

/// スポットの形式
public enum SpotType {
    /// 飲食店
    case restaurant
    /// 宿泊施設
    case hotel
    /// レジャー
    case leisure
    /// 交通機関
    case transportation
}

public class SpotListCollectionViewCell: UICollectionViewCell {
    private var spotListScrollView: UIScrollView?
    private var spotListTableView: UITableView?
    private var loadingView = LoadingView()
    private var spotType: SpotType?
    private var spotList = [SpotEntityProtocol]()
    private var settingPoints = [SettingPointEntity]()
    private var adBannerView: GADBannerView?

    private var restaurantPresenter: RestaurantSpotPresenterProrocol?
    private var hotelPresenter: HotelSpotPresenterProrocol?
    private var leisurePresenter: LeisureSpotPresenterProrocol?
    private var stationPresenter: StationSpotPresenterProrocol?
    private var busPresenter: BusStopSpotPresenterProrocol?

    public weak var delegate: SpotListCollectionViewCellDelegate?

    public func configre(spotType: SpotType) {
        self.spotType = spotType
        configrationContent()
        configureAd()
    }

    private func configrationContent() {
        spotListScrollView = UIScrollView(frame: bounds)
        guard let spotListScrollView = spotListScrollView else { return }
        addSubview(spotListScrollView)

        spotListTableView = UITableView(frame: bounds, style: .plain)
        guard let spotListTableView = spotListTableView else { return }
        spotListTableView.tableFooterView = UIView(frame: .zero)
        spotListScrollView.addSubview(spotListTableView)

        guard let loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: LoadingView.self, options: nil).first as? LoadingView else { return }
        loadingView.frame = bounds
        self.loadingView = loadingView
        addSubview(self.loadingView)

        spotListTableView.delegate = self
        spotListTableView.dataSource = self

        restaurantPresenter = RestaurantSpotPresenter(view: self, modelType: RestaurantSpotsModel.self)
        hotelPresenter = HotelSpotPresenter(view: self, modelType: HotelModel.self)
        leisurePresenter = LeisureSpotPresenter(view: self, modelType: LeisureModel.self)
        stationPresenter = StationSpotPresenter(view: self, modelType: StationModel.self)
        busPresenter = BusStopSpotPresenter(view: self, modelType: BusStopModel.self)

        spotListTableView.register(UINib(nibName: "SpotCell", bundle: nil), forCellReuseIdentifier: "SpotCell")
    }

    public func setSpotList(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) {
        switch spotType {
        case .restaurant:
            let orderType = OrderType.byDistance
            restaurantPresenter?.fetchRestaurantSpotList(interestPoint: interestPoint, order: orderType)

        case .hotel:
            hotelPresenter?.fetchHotelSpotList(interestPoint: interestPoint)

        case .leisure:
            leisurePresenter?.fetchHotelSpotList(interestPoint: interestPoint)

        case .transportation:
            stationPresenter?.fetchStationList(interestPoint: interestPoint, completion: { stations in
                self.busPresenter?.fetchBusStopList(interestPoint: interestPoint, stations: stations)
            }
            )

        default:
            break
        }

        self.settingPoints = settingPoints
    }

    public func setSpotList(spotList: [SpotEntityProtocol]) {
        DispatchQueue.main.async {
            guard let spotType = self.spotType else { return }
            self.delegate?.setNumOfSpot(num: spotList.count, spotType: spotType)

            self.spotList = spotList

            // 広告Cellの設定
            if spotList.count > 20 {
                self.insertAdElement()
            }

            self.loadingView.removeFromSuperview()
            self.spotListTableView?.reloadData()

            if spotList.isEmpty {
                self.setEmptyView(spotType: spotType)
            }
        }
    }

    private func setEmptyView(spotType: SpotType) {
        guard let emptyView = UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: self, options: nil).first as? EmptyView else { return }
        switch spotType {
        case .restaurant:
            emptyView.setEmptyType(emptyType: .restaurant)

        case .hotel:
            emptyView.setEmptyType(emptyType: .hotel)

        case .leisure:
            emptyView.setEmptyType(emptyType: .leisure)

        case .transportation:
            emptyView.setEmptyType(emptyType: .station)
        }
        emptyView.frame = bounds
        spotListTableView?.addSubview(emptyView)
    }

    private func insertAdElement() {
        for index in 0 ... spotList.count - 1 {
            if index != 0 && index % 20 == 0 {
                self.spotList.insert(AdEntity(), at: index)
            }
        }
    }

    private func configureAd() {
        // TODO: リリース時に切り替え
        // guard let adMobID = KeyManager().getValue(key: "Ad Mob ID") as? String else { return }
        let adMobID = "ca-app-pub-3940256099942544/2934735716"
        let adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = adMobID
        adBannerView.load(GADRequest())
        delegate?.setRootVC(bannerView: adBannerView)
        self.adBannerView = adBannerView
    }
}

extension SpotListCollectionViewCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let spotType = spotType else { return }
        let didSelectSpot = spotList[indexPath.row]
        if didSelectSpot is AdEntity { return }
        delegate?.setSpotTypeOfTappedSpot(spotType: spotType)
        delegate?.showSpotDetailsView(settingPoints: settingPoints, spot: didSelectSpot)
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
        guard let adBannerView = adBannerView else { return cell }
        cell.addAd(adBannerView: adBannerView)
        return cell
    }
}
