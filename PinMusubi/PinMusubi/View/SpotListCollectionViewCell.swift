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

internal class SpotListCollectionViewCell: UICollectionViewCell {
    private var spotListScrollView: UIScrollView?
    private var spotListTableView: UITableView?
    private var spotType: SpotType?
    private var spotList = [SpotEntityProtocol]()
    private var settingPoints = [SettingPointEntity]()
    private var adBannerView: GADBannerView?

    internal weak var delegate: SpotListCollectionViewCellDelegate?

    private func configureView() {
        spotListScrollView = UIScrollView(frame: bounds)
        guard let spotListScrollView = spotListScrollView else { return }
        addSubview(spotListScrollView)

        spotListTableView = UITableView(frame: bounds, style: .plain)
        guard let spotListTableView = spotListTableView else { return }
        spotListTableView.tableFooterView = UIView(frame: .zero)
        spotListScrollView.addSubview(spotListTableView)

        spotListTableView.delegate = self
        spotListTableView.dataSource = self
        spotListTableView.register(UINib(nibName: "SpotCell", bundle: nil), forCellReuseIdentifier: "SpotCell")
    }

    internal func setSpotList(settingPoints: [SettingPointEntity], spotType: SpotType, spotList: [SpotEntityProtocol]) {
        self.settingPoints = settingPoints
        self.spotType = spotType
        self.spotList = spotList

        configureView()
        configureAdView()

        delegate?.setNumOfSpot(num: spotList.count, spotType: spotType)

        guard !spotList.isEmpty else {
            setEmptyView(spotType: spotType)
            return
        }

        for index in 0 ... spotList.count - 1 {
            if index != 0 && index % 20 == 0 {
                self.spotList.insert(AdEntity(), at: index)
            }
        }
        spotListTableView?.reloadData()
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

    private func configureAdView() {
        guard let adMobID = KeyManager().getValue(key: "Ad Mob ID") as? String else { return }
        let adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = adMobID
        adBannerView.load(GADRequest())
        delegate?.setRootVC(bannerView: adBannerView)
        self.adBannerView = adBannerView
    }
}

extension SpotListCollectionViewCell: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let spotType = spotType, !(spotList[indexPath.row] is AdEntity) else { return }
        delegate?.setSpotTypeOfTappedSpot(spotType: spotType)
        delegate?.showSpotDetailsView(settingPoints: settingPoints, spot: spotList[indexPath.row])
    }

    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
}

extension SpotListCollectionViewCell: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotList.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as? SpotCell else { return SpotCell() }
        guard let adBannerView = adBannerView else { return cell }
        cell.initialize()
        cell.selectionStyle = .none
        cell.configure(spot: spotList[indexPath.row])
        cell.addAd(adBannerView: adBannerView)
        return cell
    }
}
