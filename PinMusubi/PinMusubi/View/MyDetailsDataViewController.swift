//
//  MyDetailsDataViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class MyDetailsDataViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView!

    private var myData: MyDataEntityProtocol?

    public var presenter: MyDetailsDataPresenterProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()
        stackView.removeConstraints(stackView.constraints)
        configureChildren()

        presenter = MyDetailsDataPresenter(vc: self, modelType: SearchInterestPlaceModel.self)
        configureNavigationBar()
    }

    public func setParameter(myData: MyDataEntityProtocol) {
        self.myData = myData
    }

    private func configureNavigationBar() {
        if let favoriteData = myData as? FavoriteSpotEntity {
            let interestPoint = CLLocationCoordinate2D(latitude: favoriteData.latitude, longitude: favoriteData.longitude)
            presenter?.getAddress(interestPoint: interestPoint, complete: { address in
                self.navigationItem.title = address
            }
            )
        }
    }

    private func configureChildren() {
        guard let myData = myData else { return }
        // Header
        let headerVC = MyDetailsDataHeaderViewController()
        headerVC.setParameter(myData: myData)
        addChild(headerVC)
        stackView.addArrangedSubview(headerVC.view)
        headerVC.didMove(toParent: self)
        // MyDetailsDataAction
        let myDetailsDataActionVC = MyDetailsDataActionViewController()
        addChild(myDetailsDataActionVC)
        stackView.addArrangedSubview(myDetailsDataActionVC.view)
        // TravelTimePanel
        let travelTimePanelVC = TravelTimePanelViewController()
        travelTimePanelVC.setParameter(myData: myData)
        addChild(travelTimePanelVC)
        stackView.addArrangedSubview(travelTimePanelVC.view)
        travelTimePanelVC.didMove(toParent: self)
        myDetailsDataActionVC.didMove(toParent: self)
    }

    @IBAction private func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func ditSwipeView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func didTapMenuButton(_ sender: Any) {
    }
}
