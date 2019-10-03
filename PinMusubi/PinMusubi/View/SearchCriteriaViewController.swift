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

public class SearchCriteriaViewController: UIViewController, MKMapViewDelegate, SettingBasePointsViewDelegate {
    @IBOutlet private var searchMapView: MKMapView!
    private let annotation = MKPointAnnotation()
    private var circles = [MKCircle]()
    private var lines = [MKPolyline]()
    private var circleColorNumber = 0
    private var lineColorNumber = 0
    private var settingPoints = [SettingPointEntity]()
    private var halfwayPoint = CLLocationCoordinate2D()
    private var fpc = FloatingPanelController()
    private var transferTimes = [Int]()
    private var pointsInfomationAnnotationView: PointsInfomationAnnotationView?

    override public func viewDidLoad() {
        super.viewDidLoad()
        // delegateの設定
        searchMapView.delegate = self
        fpc.delegate = self

        // モーダル表示を行う
        let modalVC = SettingBasePointsModalViewController()
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 9.0
        } else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.set(contentViewController: modalVC)
        fpc.addPanel(toParent: self, animated: true)

        // textFieldに関する通知を設定
        registerNotification()

        guard let modalContentView = modalVC.view.subviews.first as? SettingBasePointsView else { return }
        modalContentView.delegate = self

        guard let pointsInfomationAnnotationView =
            UINib(nibName: "PointsInfomationAnnotationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PointsInfomationAnnotationView else { return }
        self.pointsInfomationAnnotationView = pointsInfomationAnnotationView
    }

    /// アノテーションの設定
    /// - Parameter mapView: searchCriteriaView
    /// - Parameter annotation: annotation
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "halfwayPoint")
        pinAnnotationView.isDraggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.detailCalloutAccessoryView = pointsInfomationAnnotationView
        pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: halfwayPoint)
        return pinAnnotationView
    }

    /// ピンをドラッグした時の処理
    /// - Parameter mapView:searchCriteriaView
    /// - Parameter view: view
    /// - Parameter newState: newState
    /// - Parameter oldState: oldState
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            guard let relesePoint = view.annotation?.coordinate else { return }
            setMark(settingPoints: settingPoints, centerPoint: relesePoint)
            self.halfwayPoint = relesePoint
            pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: relesePoint)
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
            renderer.strokeColor = ColorDefinition.settingPointColors[lineColorNumber % 10]
            renderer.alpha = 0.9
            lineColorNumber += 1

        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = UIColor.white
            renderer.fillColor = ColorDefinition.settingPointColors[circleColorNumber % 10]
            renderer.alpha = 0.8
            circleColorNumber += 1

        default:
            renderer = MKPolylineRenderer(overlay: overlay)
        }
        return renderer
    }

    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        // 初期化
        searchMapView.removeOverlays(circles)
        circles = [MKCircle]()
        // 円形を描写
        circleColorNumber = 0
        let scale = mapView.region.span.latitudeDelta
        for settingPoint in settingPoints {
            let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let circle = MKCircle(center: settingPointLocation, radius: scale * 2_000)
            circles.append(circle)
            searchMapView.addOverlay(circle)
        }
    }

    /// 地図上に線のマークを設定
    /// - Parameter settingPoints: 設定地点
    /// - Parameter centerPoint: 中心となる地点
    public func setMark(settingPoints: [SettingPointEntity], centerPoint: CLLocationCoordinate2D) {
        // overlayの初期化
        searchMapView.removeOverlays(lines)
        lines = [MKPolyline]()
        // 線を描写
        lineColorNumber = 0
        for settingPoint in settingPoints {
            let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let line = MKPolyline(coordinates: [centerPoint, settingPointLocation], count: 2)
            lines.append(line)
            searchMapView.addOverlay(line)
        }
    }

    /// マップにピンを設定
    /// - Parameter settingPoints: 設定地点情報
    /// - Parameter halfwayPoint: 中間地点情報
    public func setPin(settingPoints: [SettingPointEntity], halfwayPoint: CLLocationCoordinate2D) {
        // クラス変数に代入
        self.settingPoints = settingPoints
        self.halfwayPoint = halfwayPoint

        // 中間地点にピンを設置
        self.annotation.coordinate = halfwayPoint
        self.searchMapView.addAnnotation(self.annotation)

        searchMapView.removeOverlays(circles)
        circles = [MKCircle]()
        searchMapView.removeOverlays(lines)
        lines = [MKPolyline]()

        // 地図上に線のマークを設定
        setMark(settingPoints: settingPoints, centerPoint: halfwayPoint)
        // 縮尺の取得
        var scale = getScale(settingPoints: settingPoints, centerPoint: halfwayPoint)
        let maxScale = 80.0
        if scale > maxScale {
            scale = maxScale
        }
        // 地図の表示領域の設定
        let span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
        let region = MKCoordinateRegion(center: halfwayPoint, span: span)
        searchMapView.setRegion(region, animated: true)
        pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: halfwayPoint)
    }

    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.view.endEditing(true)
    }

    /// 縮尺を取得
    /// - Parameter settingPoints: 設定地点
    /// - Parameter centerPoint: 中心となる地点
    public func getScale(settingPoints: [SettingPointEntity], centerPoint: CLLocationCoordinate2D) -> CLLocationDegrees {
        var maxDistance = 0.0
        let centerPointLocation = CLLocation(latitude: centerPoint.latitude, longitude: centerPoint.longitude)
        for settingPoint in settingPoints {
            let settingLocation = CLLocation(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let distance: Double = centerPointLocation.distance(from: settingLocation)
            if maxDistance < distance {
                maxDistance = distance
            }
        }
        let scale = (maxDistance * 2) / 80_000
        return scale
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

        notification.addObserver(
            self,
            selector: #selector(self.tappedDoneSettingView(_:)),
            name: Notification.doneSettingNotification,
            object: nil
        )
    }

    /// キーボード登場時にmodalの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func willShowKeyboard(_ notification: Notification) {
        fpc.move(to: .full, animated: true)
    }

    /// 完了ボタン押下時にmodalの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func tappedDoneSettingView(_ notification: Notification) {
        fpc.move(to: .tip, animated: true)
    }
}
