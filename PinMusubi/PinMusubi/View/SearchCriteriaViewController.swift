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
    private var circles = [MKCircle]()
    private var lines = [MKPolyline]()
    private var colorNumber = 0
    private var settingPoints = [SettingPointEntity]()
    private var halfwayPoint = CLLocationCoordinate2D()
    private var fpc = FloatingPanelController()
    private var transferTimes = [Int]()

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

        setPin(settingPoints: TestData.setTestPin().0, halfwayPoint: TestData.setTestPin().1)
    }

    /// アノテーションの設定
    /// - Parameter mapView: searchCriteriaView
    /// - Parameter annotation: annotation
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "halfwayPoint")
        pinAnnotationView.image = UIImage(named: "Pin")
        pinAnnotationView.isDraggable = true
        pinAnnotationView.canShowCallout = true
        guard let pointInfoView = UINib(nibName: "PointInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PointInfoView else { return pinAnnotationView }
        pointInfoView.setPointInfo(settingPoints: settingPoints, transferTimes: transferTimes)
        pinAnnotationView.detailCalloutAccessoryView = pointInfoView
        return pinAnnotationView
    }

    /// ピンをドラッグした時の処理
    /// - Parameter mapView:searchCriteriaView
    /// - Parameter view: view
    /// - Parameter newState: newState
    /// - Parameter oldState: oldState
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            searchMapView.removeOverlays(lines)
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
            renderer.strokeColor = ColorDefinition.settingPointColors[colorNumber % 10]
            renderer.alpha = 0.9

        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = UIColor.white
            renderer.fillColor = ColorDefinition.settingPointColors[colorNumber % 10]
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

        // 初期化
        searchMapView.removeOverlays(circles)
        searchMapView.removeOverlays(lines)
        colorNumber = 0

        // 移動距離の計算
        calculateTransferTime(complete: {
            // 中間地点にピンを設置
            self.annotation.coordinate = halfwayPoint
            self.searchMapView.addAnnotation(self.annotation)
        }
        )

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
            circles.append(circle)
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

    private func calculateTransferTime(complete: @escaping () -> Void) {
        var count = 1
        for settingPoint in settingPoints {
            // PlaceMarkを生成して出発点、目的地の座標をセット.
            let fromCoordinate = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let fromPlace = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
            let toPlace = MKPlacemark(coordinate: halfwayPoint, addressDictionary: nil)

            // Itemを生成してPlaceMarkをセット.
            let fromItem = MKMapItem(placemark: fromPlace)
            let toItem = MKMapItem(placemark: toPlace)

            // MKDirectionsRequestを生成.
            let myRequest: MKDirections.Request = MKDirections.Request()

            // 出発地のItemをセット.
            myRequest.source = fromItem

            // 目的地のItemをセット.
            myRequest.destination = toItem

            // 複数経路の検索を有効.
            myRequest.requestsAlternateRoutes = true

            // 移動手段を車に設定.
            myRequest.transportType = MKDirectionsTransportType.automobile

            // MKDirectionsを生成してRequestをセット.
            let myDirections = MKDirections(request: myRequest)

            // 経路探索.
            myDirections.calculate(completionHandler: { response, error -> Void in
                // NSErrorを受け取ったか、ルートがない場合.
                guard let routes = response?.routes else { return }
                if error != nil || routes.isEmpty {
                    return
                }
                let route: MKRoute = routes[0]
                self.transferTimes.append(Int(route.expectedTravelTime))

                if count == self.settingPoints.count {
                    complete()
                } else {
                    count += 1
                }
            }
            )
        }
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
