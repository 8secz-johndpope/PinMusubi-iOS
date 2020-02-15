//
//  PointsInfomationPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を渡すプレゼンターのプロトコル
internal protocol PointsInfomationPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type)

    func presentPointInfomationList(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D)
}

/// マップ上の地点間の情報を渡すプレゼンター
internal class PointsInfomationPresenter: PointsInfomationPresenterProrocol {
    private weak var view: PointsInfomationAnnotationView?
    private let model: PointsInfomationModelProtocol?

    /// コンストラクタ
    internal required init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    internal func presentPointInfomationList(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        guard let model = model else { return }

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue")

        var pointInfomationList = [PointInfomationEntity]()
        settingPoints.forEach { settingPoint in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                model.calculateTransferTime(settingPoint: settingPoint, pinPoint: pinPoint) { travelTime in
                    model.getTransportationGuide(settingPoint: settingPoint, pinPoint: pinPoint) {
                        pointInfomationList.append(PointInfomationEntity(travelTime: travelTime, transferGuideURLString: $0, fromStationName: $1, toStationName: $2, transferGuideResponseStatus: $3))
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.view?.setPointInfomationList(pointInfomationList: pointInfomationList)
        }
    }
}
