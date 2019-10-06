//
//  SearchInterestPlaceViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/08/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FloatingPanel
import MapKit
import UIKit

/// 興味のある場所を探すView
public class SearchInterestPlaceViewController: UIViewController {
    // MapView
    @IBOutlet private var searchMapView: MKMapView!

    /// ピンのAnnotation
    private let annotation = MKPointAnnotation()
    /// カスタムAnnotationView
    private var pointsInfomationAnnotationView: PointsInfomationAnnotationView?
    /// 円のリスト
    private var circles = [MKCircle]()
    /// 線のリスト
    private var lines = [MKPolyline]()
    /// 円の色の番号
    private var circleColorIndex = 0
    /// 線の色の番号
    private var lineColorIndex = 0
    /// 設定地点のリスト
    private var settingPoints = [SettingPointEntity]()
    /// 中間地点
    private var halfwayPoint = CLLocationCoordinate2D()
    /// モーダル
    private var floatingPanelController = FloatingPanelController()

    public var presenter: SearchInterestPlacePresenterProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()
        // delegateの設定
        searchMapView.delegate = self
        floatingPanelController.delegate = self

        // モーダル表示
        let modalVC = SettingBasePointsModalViewController()
        floatingPanelController.surfaceView.cornerRadius = 9.0
        floatingPanelController.set(contentViewController: modalVC)
        floatingPanelController.addPanel(toParent: self, animated: true)
        guard let modalContentView = modalVC.view.subviews.first as? SettingBasePointsView else { return }
        modalContentView.delegate = self

        // カスタムAnnotationViewの設定
        guard let pointsInfomationAnnotationView =
            UINib(nibName: "PointsInfomationAnnotationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PointsInfomationAnnotationView else { return }
        self.pointsInfomationAnnotationView = pointsInfomationAnnotationView

        self.presenter = SearchInterestPlacePresenter(vc: self, modelType: SearchInterestPlaceModel.self)

        // textFieldに関する通知を設定
        registerNotification()
    }
}

/// MapViewに関するDelegate
extension SearchInterestPlaceViewController: MKMapViewDelegate {
    /// ピンをドラッグした時の処理
    /// - Parameter mapView:searchMapView
    /// - Parameter view: view
    /// - Parameter newState: newState
    /// - Parameter oldState: oldState
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            guard let relesePoint = view.annotation?.coordinate else { return }
            self.halfwayPoint = relesePoint
            setLine(settingPoints: settingPoints, centerPoint: relesePoint)
            pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: relesePoint)
        }
    }

    /// アノテーションの設定
    /// - Parameter mapView: searchMapView
    /// - Parameter annotation: annotation
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "halfwayPoint")
        pinAnnotationView.isDraggable = true
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.detailCalloutAccessoryView = pointsInfomationAnnotationView
        pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: halfwayPoint)
        pointsInfomationAnnotationView?.delegate = self
        return pinAnnotationView
    }

    /// overlayを追加するイベント発生時に行うoverlayの設定
    /// - Parameter mapView: searchMapView
    /// - Parameter overlay: overlay(MKPolyline or MKCircle)
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer: MKOverlayPathRenderer
        switch overlay {
        case is MKPolyline:
            renderer = MKPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = ColorDefinition.settingPointColors[lineColorIndex % 10]
            renderer.alpha = 0.9
            lineColorIndex += 1

        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 3
            renderer.strokeColor = UIColor.white
            renderer.fillColor = ColorDefinition.settingPointColors[circleColorIndex % 10]
            renderer.alpha = 0.8
            circleColorIndex += 1

        default:
            renderer = MKPolylineRenderer(overlay: overlay)
        }
        return renderer
    }

    /// 縮尺変更時、円の大きさを変更
    /// - Parameter mapView: searchMapView
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        // 初期化
        searchMapView.removeOverlays(circles)
        circles = [MKCircle]()
        // 円形を描写
        circleColorIndex = 0
        let scale = mapView.region.span.latitudeDelta
        for settingPoint in settingPoints {
            let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let circle = MKCircle(center: settingPointLocation, radius: scale * 2_000)
            circles.append(circle)
            searchMapView.addOverlay(circle)
        }
    }

    /// 地点間に線を描写
    /// - Parameter settingPoints: 設定地点
    /// - Parameter centerPoint: 中心となる地点
    public func setLine(settingPoints: [SettingPointEntity], centerPoint: CLLocationCoordinate2D) {
        // overlayの初期化
        searchMapView.removeOverlays(lines)
        lines = [MKPolyline]()
        // 線を描写
        lineColorIndex = 0
        for settingPoint in settingPoints {
            let settingPointLocation = CLLocationCoordinate2D(latitude: settingPoint.latitude, longitude: settingPoint.longitude)
            let line = MKPolyline(coordinates: [centerPoint, settingPointLocation], count: 2)
            lines.append(line)
            searchMapView.addOverlay(line)
        }
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
        var scale = (maxDistance * 2) / 80_000
        let maxScale = 80.0
        if scale > maxScale {
            scale = maxScale
        }
        return scale
    }
}

/// モーダルに関するDelegateメソッド
extension SearchInterestPlaceViewController: FloatingPanelControllerDelegate {
    /// モーダルの設定
    /// - Parameter vc: FloatingPanelController
    /// - Parameter newCollection: UITraitCollection
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }

    /// モーダルをドラッグ時、キーボードを下げる
    /// - Parameter vc: FloatingPanelController
    public func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        self.view.endEditing(true)
    }
}

/// 地点設定のDelegate
extension SearchInterestPlaceViewController: SettingBasePointsViewDelegate {
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

        // Overlayの初期化
        searchMapView.removeOverlays(circles)
        searchMapView.removeOverlays(lines)
        circles = [MKCircle]()
        lines = [MKPolyline]()

        // 地図上に線のマークを設定
        setLine(settingPoints: settingPoints, centerPoint: halfwayPoint)
        // 縮尺の取得
        let scale = getScale(settingPoints: settingPoints, centerPoint: halfwayPoint)
        // 地図の表示領域の設定
        let span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
        let region = MKCoordinateRegion(center: halfwayPoint, span: span)
        searchMapView.setRegion(region, animated: true)
        pointsInfomationAnnotationView?.setPointInfo(settingPoints: settingPoints, pinPoint: halfwayPoint)
    }
}

extension SearchInterestPlaceViewController: PointInfomationAnnotationViewDelegate {
    public func searchSpotList() {
        guard let presenter = presenter else { return }
        if presenter.setSearchHistrory(settingPoints: settingPoints, interestPoint: halfwayPoint) {
            // TODO: 次の画面への処理を実装
            print("次の画面へ")
        } else {
            // TODO: エラーのポップアップ表示実装
            print("エラーのポップアップ")
        }
    }
}

/// 通知設定
public extension SearchInterestPlaceViewController {
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
        floatingPanelController.move(to: .full, animated: true)
    }

    /// 完了ボタン押下時にmodalの高さを制御
    /// - Parameter notification: 通知設定
    @objc
    func tappedDoneSettingView(_ notification: Notification) {
        floatingPanelController.move(to: .tip, animated: true)
    }
}
