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

public class SearchCriteriaViewController: UIViewController, MKMapViewDelegate, ModalContentViewDelegate {
    @IBOutlet private var searchMapView: MKMapView!
    private let annotation = MKPointAnnotation()
    private var lines = [MKPolyline]()
    private var colorNumber = 0
    private var settingPoints = [SettingPointEntity]()
    private var halfwayPoint = CLLocationCoordinate2D()
    private var fpc = FloatingPanelController()

    override public func viewDidLoad() {
        super.viewDidLoad()
        // delegateの設定
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

        // textFieldに関する通知を設定
        registerNotification()

        guard let modalContentView = modalVC.view.subviews.first as? ModalContentView else { return }
        modalContentView.delegate = self

        ///TODO テストデータ後で消す
        setPin(settingPoints: TestData.setTestPin().0, halfwayPoint: TestData.setTestPin().1)
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

    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.view.endEditing(true)
    }

    @IBAction private func didTapView(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension SearchCriteriaViewController: FloatingPanelControllerDelegate {
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }

    public func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        self.view.endEditing(true)
    }
}

public extension SearchCriteriaViewController {
    /// 通知登録
    func registerNotification() {
        // 通知センターの取得
        let notification = NotificationCenter.default
        // キーボード登場通知の設定
        notification.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    /// キーボード登場時にtextFieldの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func willShowKeyboard(_ notification: Notification) {
        fpc.move(to: .full, animated: true)
    }
}
