//
//  SearchInterestPlaceViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/08/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import FirebaseAnalytics
import FloatingPanel
import GoogleMobileAds
import MapKit
import UIKit

/// 興味のある場所を探すView
public class SearchInterestPlaceViewController: UIViewController {
    @IBOutlet private var searchMapView: MKMapView! {
        didSet {
            searchMapView.delegate = self
        }
    }

    private var pointsInfomationAnnotationView: PointsInfomationAnnotationView?
    private var floatingPanelController = FloatingPanelController()
    private let annotation = MKPointAnnotation()
    private var circles = [MKCircle]()
    private var lines = [MKPolyline]()
    private var circleColorIndex = 0
    private var lineColorIndex = 0
    private var settingPoints = [SettingPointEntity]()
    private var halfwayPoint = CLLocationCoordinate2D()
    private var spotListNC: SpotListNavigationController?
    private var dragPinTimes = 0
    private var topAdMobView: GADBannerView?
    private var bottomAdMobView: GADBannerView?

    public var presenter: SearchInterestPlacePresenterProtocol?

    override public func viewDidLoad() {
        super.viewDidLoad()

        presenter = SearchInterestPlacePresenter(vc: self, modelType: SearchInterestPlaceModel.self)

        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 9.0
        floatingPanelController.addPanel(toParent: self, animated: true)

        let modalVC = SettingBasePointsModalViewController()
        floatingPanelController.set(contentViewController: modalVC)
        guard let modalContentView = modalVC.view.subviews.first as? SettingBasePointsView else { return }
        modalContentView.delegate = self

        guard let nibAnotationView =
            UINib(nibName: "PointsInfomationAnnotationView", bundle: nil).instantiate(withOwner: self, options: nil).first as? PointsInfomationAnnotationView else { return }
        pointsInfomationAnnotationView = nibAnotationView

        registerTextFieldNotification()
    }

    override public func viewWillLayoutSubviews() {
        if topAdMobView == nil || bottomAdMobView == nil {
            configureTopAdMobView()
            configureBottomAdMobView()
        }
        showTutorialView()
        checkCurrentVersion()
    }

    private func configureTopAdMobView() {
        guard let adMobID = KeyManager().getValue(key: "Ad Mob ID") as? String else { return }
        topAdMobView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        guard let topAdMobView = topAdMobView else { return }
        topAdMobView.frame.origin = CGPoint(x: (view.frame.width - topAdMobView.bounds.width) / 2, y: view.safeAreaInsets.top)
        topAdMobView.adUnitID = adMobID
        topAdMobView.rootViewController = self
        topAdMobView.load(GADRequest())
        topAdMobView.isHidden = true
        view.addSubview(topAdMobView)
    }

    private func configureBottomAdMobView() {
        guard let adMobID = KeyManager().getValue(key: "Ad Mob ID") as? String else { return }
        bottomAdMobView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        guard let bottomAdMobView = bottomAdMobView else { return }
        let screenHeight = UIScreen.main.bounds.size.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let bottomAdMobViewY = screenHeight - safeAreaBottom - bottomAdMobView.bounds.height - 60
        bottomAdMobView.frame.origin = CGPoint(x: (view.frame.width - bottomAdMobView.bounds.width) / 2, y: bottomAdMobViewY)
        bottomAdMobView.adUnitID = adMobID
        bottomAdMobView.rootViewController = self
        bottomAdMobView.load(GADRequest())
        bottomAdMobView.isHidden = true
        view.addSubview(bottomAdMobView)
    }

    private func showTutorialView() {
        if (UserDefaults.standard.value(forKey: "firstLaunch") as? Bool) == nil {
            let tutorialSV = UIStoryboard(name: "TutorialCollectionViewController", bundle: nil)
            guard let tutorialVC = tutorialSV.instantiateInitialViewController() as? TutorialCollectionViewController else { return }
            tutorialVC.modalPresentationStyle = .fullScreen
            present(tutorialVC, animated: true, completion: nil)

            UserDefaults.standard.set(true, forKey: "firstLaunch")

            if let latestVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                UserDefaults.standard.set(latestVersion, forKey: "currentVersion")
            }
        }
    }

    private func checkCurrentVersion() {
        if let latestVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            if let currentVersion = UserDefaults.standard.value(forKey: "currentVersion") as? String {
                if currentVersion != latestVersion {
                    UserDefaults.standard.set(latestVersion, forKey: "currentVersion")
                    showVersionInfoView()
                }
            } else {
                UserDefaults.standard.set(latestVersion, forKey: "currentVersion")
                showVersionInfoView()
            }
        }
    }

    private func showVersionInfoView() {
        let versionInfoSV = UIStoryboard(name: "VersionInfoViewController", bundle: nil)
        guard let versionInfoVC = versionInfoSV.instantiateInitialViewController() as? VersionInfoViewController else { return }
        versionInfoVC.modalTransitionStyle = .crossDissolve
        present(versionInfoVC, animated: true, completion: nil)
    }

    internal func moveFloatingPanel(position: FloatingPanelPosition) {
        floatingPanelController.move(to: position, animated: true)
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
            dragPinTimes += 1
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
        topAdMobView?.isHidden = true
        bottomAdMobView?.isHidden = true
        view.endEditing(true)
    }

    public func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        switch vc.position {
        case .tip:
            topAdMobView?.isHidden = true
            bottomAdMobView?.isHidden = false

        case .half:
            topAdMobView?.isHidden = true
            bottomAdMobView?.isHidden = true

        case .full:
            topAdMobView?.isHidden = false
            bottomAdMobView?.isHidden = true

        case .hidden:
            break
        }
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
        annotation.coordinate = halfwayPoint
        searchMapView.addAnnotation(annotation)

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

        // パラメータ初期化
        dragPinTimes = 0
    }

    public func moveModalToFull() {
        floatingPanelController.move(to: .full, animated: true)
    }

    public func showSearchCompleterView(inputEditingCell: SettingBasePointCell) {
        let searchCompleterSV = UIStoryboard(name: "SearchCompleterViewController", bundle: nil)
        guard let searchCompleterNC = searchCompleterSV.instantiateInitialViewController() as? SearchCompleterNavigationController else { return }
        guard let searchCompleterVC = searchCompleterNC.topViewController as? SearchCompleterViewController else { return }
        searchCompleterVC.setInputEditingCellInstance(inputEditingCell: inputEditingCell)
        present(searchCompleterNC, animated: true, completion: nil)
    }
}

extension SearchInterestPlaceViewController: PointInfomationAnnotationViewDelegate {
    public func searchSpotList() {
        guard let presenter = presenter else { return }
        if presenter.setSearchHistrory(settingPoints: settingPoints, interestPoint: halfwayPoint) {
            Analytics.logEvent(
                "show_spot_list",
                parameters: [
                    "times_of_drag_pin": dragPinTimes as NSObject,
                    "number_of_setting_pin": settingPoints.count as NSObject
                ]
            )
            showSpotListView(settingPoints: settingPoints, interestPoint: halfwayPoint)
        }
    }

    public func showShareActivity(activityVC: UIActivityViewController) {
        present(activityVC, animated: true, completion: nil)
    }

    public func showTransportationGuideWebPage(webVCInstance: WebViewController) {
        present(webVCInstance, animated: true, completion: nil)
    }
}

extension SearchInterestPlaceViewController: SpotListViewDelegate {
    private func showSpotListView(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D) {
        presenter?.getAddress(interestPoint: interestPoint) { address in
            let spotListSV = UIStoryboard(name: "SpotListViewController", bundle: nil)
            self.spotListNC = spotListSV.instantiateInitialViewController() as? SpotListNavigationController
            guard let spotListNC = self.spotListNC else { return }
            guard let spotListVC = spotListNC.topViewController as? SpotListViewController else { return }
            spotListVC.delegate = self
            spotListVC.setParameter(settingPoints: settingPoints, interestPoint: interestPoint, address: address)
            spotListNC.modalPresentationStyle = .fullScreen
            self.present(spotListNC, animated: true, completion: nil)
        }
    }

    public func closeSpotListView() {
        spotListNC?.dismiss(animated: true, completion: nil)
    }

    public func showDoneRegisterView() {
        floatingPanelController.move(to: .tip, animated: true)
        spotListNC?.dismiss(animated: true, completion: {
            let doneRegisterSV = UIStoryboard(name: "DoneRegisterViewController", bundle: nil)
            guard let doneRegisterVC = doneRegisterSV.instantiateViewController(withIdentifier: "DoneRegisterViewController") as? DoneRegisterViewController else { return }
            doneRegisterVC.modalPresentationStyle = .custom
            doneRegisterVC.transitioningDelegate = self
            self.present(doneRegisterVC, animated: true, completion: nil)
        }
        )
    }
}

/// 通知設定
public extension SearchInterestPlaceViewController {
    /// 通知登録
    func registerTextFieldNotification() {
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

extension SearchInterestPlaceViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DoneRegisterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
