//
//  SpotInfomationView.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

class SpotInfomationView: UIView {
    @IBOutlet private var stackView: UIStackView! {
        didSet {
            stackView.removeConstraints(stackView.constraints)
        }
    }

    @IBOutlet private var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 15
            backgroundView.backgroundColor = UIColor(hex: "AAAAAA", alpha: 0.1)
        }
    }

    func setContents(spot: SpotEntity) {
        if let address = spot.address {
            let addressCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let addressCell = addressCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let addressImage = UIImage(named: "Pin") ?? UIImage()
            addressCell.setContents(image: addressImage, text: address)
            stackView.addArrangedSubview(addressCell)
        }

        if let phoneNumber = spot.phoneNumber {
            let phoneNumberCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let phoneNumberCell = phoneNumberCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let phoneNumberImage = UIImage(named: "PhoneNumberIcon") ?? UIImage()
            phoneNumberCell.setContents(image: phoneNumberImage, text: phoneNumber)
            stackView.addArrangedSubview(phoneNumberCell)
        }

        if let spotInfomation = spot.spotInfomation {
            switch spotInfomation {
            case let shop as HotpepperShop:
                setHotpepperShop(shop)

            case let hotel as RakutenTravelHotelBasicInfo:
                setRakutenTravelHotelBasicInfo(hotel)

            case let feature as YOLPFeature:
                setYOLPFeature(feature)

            default:
                return
            }
        }
    }

    // Hotpepper API
    private func setHotpepperShop(_ shop: HotpepperShop) {
        // お店キャッチ
        let shopCatchCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let shopCatchCell = shopCatchCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let shopCatchImage = UIImage(named: "ShopCatchIcon") ?? UIImage()
        shopCatchCell.setContents(image: shopCatchImage, text: shop.shopCatch)
        stackView.addArrangedSubview(shopCatchCell)

        // 平均ディナー予算
        let budgetCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let budgetCell = budgetCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let budgetImage = UIImage(named: "BudgetIcon") ?? UIImage()
        budgetCell.setContents(image: budgetImage, text: "予算：\(shop.budget.average)")
        stackView.addArrangedSubview(budgetCell)

        // 総席数
        let capacityCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let capacityCell = capacityCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let capacityImage = UIImage(named: "SeatIcon") ?? UIImage()
        capacityCell.setContents(image: capacityImage, text: "総席数：\(shop.capacity)")
        stackView.addArrangedSubview(capacityCell)

        // 交通アクセス
        let accessCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let accessCell = accessCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let accessImage = UIImage(named: "AccessIcon") ?? UIImage()
        accessCell.setContents(image: accessImage, text: "アクセス：\(shop.access)")
        stackView.addArrangedSubview(accessCell)

        // 営業時間
        let openCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let openCell = openCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let openImage = UIImage(named: "OpenIcon") ?? UIImage()
        openCell.setContents(image: openImage, text: "営業時間：\(shop.open)")
        stackView.addArrangedSubview(openCell)

        // 定休日
        let closeCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let closeCell = closeCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let closeImage = UIImage(named: "CloseIcon") ?? UIImage()
        closeCell.setContents(image: closeImage, text: "定休日：\(shop.close)")
        stackView.addArrangedSubview(closeCell)

        // 駐車場
        let parkingCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let parkingCell = parkingCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let parkingImage = UIImage(named: "ParkingIcon") ?? UIImage()
        parkingCell.setContents(image: parkingImage, text: "駐車場：\(shop.parking)")
        stackView.addArrangedSubview(parkingCell)

        // カード可
        let cardCellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
        guard let cardCell = cardCellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
        let cardImage = UIImage(named: "CardIcon") ?? UIImage()
        cardCell.setContents(image: cardImage, text: "カード：\(shop.card)")
        stackView.addArrangedSubview(cardCell)
    }

    // Rakuten Travel API
    private func setRakutenTravelHotelBasicInfo(_ hotel: RakutenTravelHotelBasicInfo) {
        // 最安料金
        if let minCarge = hotel.hotelMinCharge {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "BudgetIcon") ?? UIImage()
            cell.setContents(image: image, text: "最安予算：\(minCarge)")
            stackView.addArrangedSubview(cell)
        }

        // 星の数
        if let review = hotel.reviewAverage {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "ReviewIcon") ?? UIImage()
            cell.setContents(image: image, text: "レビュー平均：\(review)")
            stackView.addArrangedSubview(cell)
        }

        // お客様の声
        if let userReview = hotel.userReview {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "ShopCatchIcon") ?? UIImage()
            cell.setContents(image: image, text: "お客さまの声：\(userReview)")
            stackView.addArrangedSubview(cell)
        }

        // 施設へのアクセス
        if let access = hotel.access {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "AccessIcon") ?? UIImage()
            cell.setContents(image: image, text: "アクセス：\(access)")
            stackView.addArrangedSubview(cell)
        }

        // 駐車場情報
        if let parking = hotel.parkingInformation {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "ParkingIcon") ?? UIImage()
            cell.setContents(image: image, text: "駐車場：\(parking)")
            stackView.addArrangedSubview(cell)
        }
    }

    private func setYOLPFeature(_ feature: YOLPFeature) {
        // キャッチコピー
        if let catchCopy = feature.property.catchCopy {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "ShopCatchIcon") ?? UIImage()
            cell.setContents(image: image, text: "キャッチコピー：\(catchCopy)")
            stackView.addArrangedSubview(cell)
        }

        // 料金
        if let price = feature.property.price {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "BudgetIcon") ?? UIImage()
            cell.setContents(image: image, text: "料金：\(price)")
            stackView.addArrangedSubview(cell)
        }

        // アクセス
        if let access = feature.property.access1 {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "AccessIcon") ?? UIImage()
            cell.setContents(image: image, text: "アクセス：\(access)")
            stackView.addArrangedSubview(cell)
        }

        // 駐車場
        if let parking = feature.property.parkingFlag {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "ParkingIcon") ?? UIImage()
            cell.setContents(image: image, text: "駐車場：\(parking)")
            stackView.addArrangedSubview(cell)
        }

        // カード
        if let card = feature.property.creditcardFlag {
            let cellNib = UINib(nibName: "SpotInfomationCell", bundle: nil)
            guard let cell = cellNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationCell else { return }
            let image = UIImage(named: "CardIcon") ?? UIImage()
            cell.setContents(image: image, text: "カード：\(card)")
            stackView.addArrangedSubview(cell)
        }
    }
}
