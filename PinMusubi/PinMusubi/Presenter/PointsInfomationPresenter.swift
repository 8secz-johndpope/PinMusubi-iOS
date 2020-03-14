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

    private var settingPoints = [SettingPointEntity]()
    private var pinPoint = CLLocationCoordinate2D()
    private var pointInfomationList = [PointInfomationEntity]()
    private var transportation = Transportation.walk

    /// コンストラクタ
    required init(view: PointsInfomationAnnotationView, modelType model: PointsInfomationModelProtocol.Type) {
        self.view = view
        self.model = model.init()
    }

    func presentPointInfomationList(
        settingPoints: [SettingPointEntity],
        pinPoint: CLLocationCoordinate2D,
        pointInfomationList: [PointInfomationEntity],
        transportation: Transportation
    ) {
        self.settingPoints = settingPoints
        self.pinPoint = pinPoint
        self.pointInfomationList = pointInfomationList
        self.transportation = transportation

        if pointInfomationList.isEmpty {
            fetchPointInfomation()
        } else {
            addPointInfomation()
        }
    }

    private func fetchPointInfomation() {
        var transportationTime = [Int]()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "fetchPointInfomation", attributes: .concurrent)

        self.settingPoints.forEach { settingPoint in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                self.model?.calculateTransferTime(settingPoint: settingPoint, pinPoint: self.pinPoint) {
                    transportationTime.append($0)
                    dispatchGroup.leave()
                }
            }
        }

        self.settingPoints.forEach { settingPoint in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                self.model?.getTransportationGuide(settingPoint: settingPoint, pinPoint: self.pinPoint) { transferGuideURLString, fromStationName, toStationName in
                    self.pointInfomationList.append(
                        PointInfomationEntity(
                            transferGuideURLString: transferGuideURLString,
                            fromStationName: fromStationName,
                            toStationName: toStationName
                        )
                    )
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            for index in 0...self.settingPoints.count - 1 {
                switch self.transportation {
                case .walk:
                    self.pointInfomationList[index].walkTime = transportationTime[index]

                case .bicycle:
                    self.pointInfomationList[index].bicycleTime = transportationTime[index]

                case .car:
                    self.pointInfomationList[index].carTime = transportationTime[index]

                case .train:
                    self.pointInfomationList[index].bicycleTime = transportationTime[index]
                }
            }
            self.view?.setPointInfomationList(pointInfomationList: self.pointInfomationList)
        }
    }

    private func addPointInfomation() {
        var isFetchTransportationTime = true

        switch transportation {
        case .walk:
            isFetchTransportationTime = pointInfomationList.first?.walkTime == nil

        case .bicycle:
            isFetchTransportationTime = pointInfomationList.first?.bicycleTime == nil

        case .car:
            isFetchTransportationTime = pointInfomationList.first?.carTime == nil

        case .train:
            break
        }

        if isFetchTransportationTime {
            var transportationTime = [Int]()

            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "addPointInfomation", attributes: .concurrent)

            self.settingPoints.forEach { settingPoint in
                dispatchGroup.enter()
                dispatchQueue.async(group: dispatchGroup) {
                    self.model?.calculateTransferTime(settingPoint: settingPoint, pinPoint: self.pinPoint) {
                        transportationTime.append($0)
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                for index in 0...self.settingPoints.count - 1 {
                    switch self.transportation {
                    case .walk:
                        self.pointInfomationList[index].walkTime = transportationTime[index]

                    case .bicycle:
                        self.pointInfomationList[index].bicycleTime = transportationTime[index]

                    case .car:
                        self.pointInfomationList[index].carTime = transportationTime[index]

                    case .train:
                        self.pointInfomationList[index].bicycleTime = transportationTime[index]
                    }
                }
                self.view?.setPointInfomationList(pointInfomationList: self.pointInfomationList)
            }
        }
    }
}
