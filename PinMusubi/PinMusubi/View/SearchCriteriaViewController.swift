//
//  ViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/08/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FloatingPanel
import MapKit
import UIKit

public class SearchCriteriaViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private var searchMapView: MKMapView!
    private let annotation = MKPointAnnotation()
    private var lines = [MKPolyline]()
    private var colorNumber = 0
    private var settingPoints = [SettingPointEntity]()
    private var halfwayPoint = CLLocationCoordinate2D()
    private var fpc = FloatingPanelController()

    override public func viewDidLoad() {
        super.viewDidLoad()

        searchMapView.delegate = self
        fpc.delegate = self

        // モーダル表示を行う
        let modalVC = SearchCriteriaModalViewController()
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 9.0
        } else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.set(contentViewController: modalVC)
        fpc.addPanel(toParent: self, animated: true)

        ///TODO テストデータ後で消す
        setPin(settingPoints: TestData.setTestPin().0, halfwayPoint: TestData.setTestPin().1)
    }

    /// ビューが非表示になり始める時の設定
    /// - Parameter animated: animationを行うか
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // セミモーダルビューを非表示に設定
        fpc.removePanelFromParent(animated: true)
    }

    /// アノテーションの設定
    /// - Parameter mapView: searchCriteriaView
    /// - Parameter annotation: annotation
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "halfwayPoint")
        pinAnnotationView.isDraggable = true
        pinAnnotationView.canShowCallout = true
        return pinAnnotationView
    }

    /// ピンをドラッグした時の処理
    /// - Parameter mapView:searchCriteriaView
    /// - Parameter view: view
    /// - Parameter newState: newState
    /// - Parameter oldState: oldState
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .starting {
            for line in lines {
                searchMapView.removeOverlay(line)
            }
        }

        if newState == .ending {
            guard let relesePoint = view.annotation?.coordinate else { return }
            self.halfwayPoint = relesePoint
            colorNumber -= settingPoints.count
            for settingPoint in settingPoints {
                let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
                let line = MKPolyline(coordinates: [halfwayPoint, settingPointLocation], count: 2)
                lines.append(line)
                searchMapView.addOverlay(line)
                if colorNumber < ColorDefinition.settingPointColors.count - 1 {
                    colorNumber += 1
                } else {
                    colorNumber = 0
                }
            }
        }
    }

    /// overlayを追加するイベント発生時に行うoverlayの設定
    /// - Parameter mapView: searchCriteriaView
    /// - Parameter overlay: overlay(MKPolyline or MKCircle)
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer: MKOverlayPathRenderer

        switch overlay {
        case is MKPolyline:
            renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = ColorDefinition.settingPointColors[colorNumber]
            renderer.alpha = 0.7

        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = UIColor.white
            renderer.fillColor = ColorDefinition.settingPointColors[colorNumber]
            renderer.alpha = 0.8

        default:
            renderer = MKPolylineRenderer(overlay: overlay)
        }
        return renderer
    }

    /// マップにピンを設定
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter halfwayPoint: 中間地点情報
    public func setPin(settingPoints: [SettingPointEntity], halfwayPoint: CLLocationCoordinate2D) {
        // クラス変数に代入
        self.settingPoints = settingPoints
        self.halfwayPoint = halfwayPoint

        // 中間地点にピンを設置
        annotation.coordinate = halfwayPoint
        searchMapView.addAnnotation(annotation)

        // 地図の表示領域の設定
        guard let settingPointFirstLatitude = settingPoints.first?.latitude,
            let settingPointFirstLongitude = settingPoints.first?.longitude else {
                return
        }
        let settingPointFirst = CLLocation(latitude: settingPointFirstLatitude, longitude: settingPointFirstLongitude)
        let halfPointLocation = CLLocation(latitude: halfwayPoint.latitude, longitude: halfwayPoint.longitude)
        let distance = halfPointLocation.distance(from: settingPointFirst)
        let delta = (distance * 2) / 80_000
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: halfwayPoint, span: span)
        searchMapView.setRegion(region, animated: true)

        // 円形と線を描写
        for settingPoint in settingPoints {
            let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let circle = MKCircle(center: settingPointLocation, radius: delta * 2_000)
            let line = MKPolyline(coordinates: [halfwayPoint, settingPointLocation], count: 2)
            lines.append(line)
            searchMapView.addOverlay(circle)
            searchMapView.addOverlay(line)
            if colorNumber < ColorDefinition.settingPointColors.count - 1 {
                colorNumber += 1
            } else {
                colorNumber = 0
            }
        }
    }
}

extension SearchCriteriaViewController: FloatingPanelControllerDelegate {
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        switch newCollection.verticalSizeClass {
        case .compact:
            fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return CustomFloatingPanelLayout()

        default:
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = nil
            return nil
        }
    }
}
