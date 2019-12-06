//
//  MyDetailsDataPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation

public protocol MyDetailsDataPresenterProtocol: AnyObject {
    init(vc: MyDetailsDataViewController, modelType model: SearchInterestPlaceModelProtocol.Type)

    func getAddress(interestPoint: CLLocationCoordinate2D, complete: @escaping (String) -> Void)
}

public class MyDetailsDataPresenter: MyDetailsDataPresenterProtocol {
    private weak var vc: MyDetailsDataViewController?
    private let model: SearchInterestPlaceModelProtocol?

    public required init(vc: MyDetailsDataViewController, modelType model: SearchInterestPlaceModelProtocol.Type) {
        self.vc = vc
        self.model = model.init()
    }

    public func getAddress(interestPoint: CLLocationCoordinate2D, complete: @escaping (String) -> Void) {
        guard let model = model else { return }
        model.getAddress(point: interestPoint) { address, _ in
            complete(address)
        }
    }
}
