//
//  SpotMapView.swift
//  PinMusubi
//
//  Created by rMac on 2020/03/02.
//  Copyright © 2020 naipaka. All rights reserved.
//

import MapKit
import UIKit

class SpotMapView: UIView {
    @IBOutlet private var backgraoundView: UIView! {
        didSet {
            backgraoundView.layer.cornerRadius = 15
        }
    }

    @IBOutlet private var mapView: MKMapView!

    func setLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        mapView.layer.cornerRadius = 15
    }

    func setContents(spot: SpotEntity) {
        let coordinate = CLLocationCoordinate2D(
            latitude: spot.latitude,
            longitude: spot.longitude
        )

        // region
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002
        region.center = coordinate

        // annotation
        let spotPointAnnotation = MKPointAnnotation()
        spotPointAnnotation.coordinate = coordinate
        spotPointAnnotation.title = spot.name
        spotPointAnnotation.subtitle = spot.category

        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(spotPointAnnotation)
    }
}
