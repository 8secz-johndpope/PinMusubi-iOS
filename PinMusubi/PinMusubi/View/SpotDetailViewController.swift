//
//  SpotDetailViewController.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {
    @IBOutlet private var stackView: UIStackView! {
        didSet {
            stackView.removeConstraints(stackView.constraints)
        }
    }

    var spot: SpotEntity?

    func setup(spot: SpotEntity) {
        self.spot = spot
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLargeTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = spot?.name
        setContents()
    }

    func setContents() {
        guard let spot = spot else { return }

        // SpotMainView
        let spotMainViewNib = UINib(nibName: "SpotMainView", bundle: nil)
        guard let spotMainView = spotMainViewNib.instantiate(withOwner: nil, options: nil).first as? SpotMainView else { return }
        spotMainView.setContents(spot: spot)
        spotMainView.setLayout()
        stackView.addArrangedSubview(spotMainView)

        // SpotWebInfomationView
        if spot.url != nil {
            let spotWebInfomationViewNib = UINib(nibName: "SpotWebInfomationView", bundle: nil)
            guard let spotWebInfomationView = spotWebInfomationViewNib.instantiate(withOwner: nil, options: nil).first as? SpotWebInfomationView else { return }
            spotWebInfomationView.delegate = self
            stackView.addArrangedSubview(spotWebInfomationView)
        }

        // SpotInfomationView
        let spotInfomationViewNib = UINib(nibName: "SpotInfomationView", bundle: nil)
        guard let spotInfomationView = spotInfomationViewNib.instantiate(withOwner: nil, options: nil).first as? SpotInfomationView else { return }
        spotInfomationView.setContents(spot: spot)
        stackView.addArrangedSubview(spotInfomationView)

        // SpotMapView
        let spotMapViewNib = UINib(nibName: "SpotMapView", bundle: nil)
        guard let spotMapView = spotMapViewNib.instantiate(withOwner: nil, options: nil).first as? SpotMapView else { return }
        spotMapView.setContents(spot: spot)
        spotMapView.setLayout()
        stackView.addArrangedSubview(spotMapView)
    }
}

extension SpotDetailViewController: SpotDetailViewDelegate {
    func presentWebView() {
        let webView = UIStoryboard(name: "WebView", bundle: nil)
        guard let webVC = webView.instantiateInitialViewController() as? WebViewController else { return }
        guard let spot = spot else { return }
        webVC.setSpot(spot: spot)
        navigationController?.show(webVC, sender: nil)
    }
}
