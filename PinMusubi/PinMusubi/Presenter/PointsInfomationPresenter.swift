//
//  PointsInfomationPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/25.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

/// マップ上の地点間の情報を渡すプレゼンターのプロトコル
protocol PointsInfomationPresenterProrocol: AnyObject {
    /// コンストラクタ
    init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type)

    func presentPointInfomationList(
        settingPoints: [SettingPointEntity],
        pinPoint: CLLocationCoordinate2D,
        pointInfomationList: [PointInfomationEntity],
        transportation: Transportation
    )
}

/// マップ上の地点間の情報を渡すプレゼンター
class PointsInfomationPresenter: PointsInfomationPresenterProrocol {
    private weak var view: PointsInfomationAnnotationView?
    private let model: PointsInfomationModelProtocol?

    /// コンストラクタ
    required init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    func presentPointInfomationList(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, pointInfomationList: [PointInfomationEntity], transportation: Transportation) {
        if pointInfomationList.isEmpty {
            fetchPointInfomation(settingPoints: settingPoints, pinPoint: pinPoint, transportation: transportation)
        } else {
            addPointInfomation(settingPoints: settingPoints, pinPoint: pinPoint, pointInfomationList: pointInfomationList, transportation: transportation)
        }
    }

    private func fetchPointInfomation(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, transportation: Transportation) {
        var pointInfomationList = [PointInfomationEntity]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchPointInfomation")

        for index in 0...settingPoints.count - 1 {
            pointInfomationList.append(PointInfomationEntity())
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                self.model?.calculateTransferTime(settingPoint: settingPoints[index], pinPoint: pinPoint, transportation: transportation) { transportationTime, distance in
                    self.model?.getTransportationGuide(settingPoint: settingPoints[index], pinPoint: pinPoint) { transferGuideURLString, fromStationName, toStationName in
                        pointInfomationList[index].transferGuideURLString = transferGuideURLString
                        pointInfomationList[index].fromStationName = fromStationName
                        pointInfomationList[index].toStationName = toStationName
                        self.setTransportationTime(pointInfomation: pointInfomationList[index], transportation: transportation, transportationTime: transportationTime, distance: distance)
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.view?.setPointInfomationList(pointInfomationList: pointInfomationList)
            }
        }
    }

    private func addPointInfomation(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D, pointInfomationList: [PointInfomationEntity], transportation: Transportation) {
        var isFetchTransportationTime = true

        switch transportation {
        case .walk:
            isFetchTransportationTime = pointInfomationList.first?.walkTime == nil

        case .bicycle:
            isFetchTransportationTime = pointInfomationList.first?.bicycleTime == nil

        case .car:
            isFetchTransportationTime = pointInfomationList.first?.carTime == nil

        case .train, .distance:
            break
        }

        if isFetchTransportationTime {
            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "addPointInfomation", attributes: .concurrent)

            for index in 0...settingPoints.count - 1 {
                dispatchGroup.enter()
                dispatchQueue.async(group: dispatchGroup) {
                    self.model?.calculateTransferTime(settingPoint: settingPoints[index], pinPoint: pinPoint, transportation: transportation) { transportationTime, distance in
                        self.setTransportationTime(pointInfomation: pointInfomationList[index], transportation: transportation, transportationTime: transportationTime, distance: distance)
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.view?.setPointInfomationList(pointInfomationList: pointInfomationList)
            }
        }
    }

    private func setTransportationTime(pointInfomation: PointInfomationEntity, transportation: Transportation, transportationTime: Int, distance: Double) {
        switch transportation {
        case .walk:
            pointInfomation.walkTime = transportationTime

        case .bicycle:
            pointInfomation.bicycleTime = transportationTime

        case .car:
            pointInfomation.carTime = transportationTime

        case .train:
            pointInfomation.walkTime = transportationTime

        case .distance:
            break
        }
        pointInfomation.distance = distance
    }
}
