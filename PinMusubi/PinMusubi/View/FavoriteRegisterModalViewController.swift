//
//  FavoriteRegisterModalViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/04.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Cosmos
import FirebaseAnalytics
import UIKit

public class FavoriteRegisterModalViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    @IBOutlet private var favoriteTitleView: UIView! {
        didSet {
            favoriteTitleView.layer.cornerRadius = 5
        }
    }

    @IBOutlet private var favoriteTitleTextField: UITextField! {
        didSet {
            favoriteTitleTextField.delegate = self
        }
    }

    @IBOutlet private var ratingView: CosmosView!
    @IBOutlet private var favoriteMemoView: UIView! {
        didSet {
            favoriteMemoView.layer.cornerRadius = 5
        }
    }
    @IBOutlet private var favoriteMemoTextView: UITextView! {
        didSet {
            favoriteMemoTextView.delegate = self
        }
    }

    @IBOutlet private var registerButton: UIButton! {
        didSet {
            registerButton.layer.cornerRadius = 5
        }
    }

    private var activeTextField: AnyObject?
    private let toolBarHeight: CGFloat = 40
    private let headerHeight: CGFloat = 53
    private var settingPoints: [SettingPointEntity]?
    private var interestPoint: CLLocationCoordinate2D?
    private var spotListAnalyticsEntity: SpotListAnalyticsEntity?
    private var favoriteId: String?

    public var presenter: FavoriteSpotPresenterProtocol?
    public weak var delegate: FavoriteRegisterModalViewDelegate?
    public weak var doneDelegate: FavoriteRegisterModalViewDoneDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        presenter = FavoriteSpotPresenter(vc: self, modelType: FavoriteSpotModel.self)

        configureKeybord()
        configureNotification()
        configureForm()
        configureRegisterButton()

        ratingView.didFinishTouchingCosmos = { rating in
            self.configureRegisterButton()
        }

        if favoriteId != nil {
            registerButton.setTitle("更新する", for: .normal)
        }
    }

    public func setParameter(settingPoints: [SettingPointEntity], interestPoint: CLLocationCoordinate2D, spotListAnalyticsEntity: SpotListAnalyticsEntity) {
        self.settingPoints = settingPoints
        self.interestPoint = interestPoint
        self.spotListAnalyticsEntity = spotListAnalyticsEntity
    }

    public func setEditParameter(favoriteId: String) {
        self.favoriteId = favoriteId
    }

    private func configureKeybord() {
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBarHeight)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        tools.items = [spacer, closeButton]
        favoriteMemoTextView.inputAccessoryView = tools
    }

    private func configureForm() {
        if let favoriteId = favoriteId {
            let model = MyDataModel()
            let favoriteSpot = model.fetchFavoriteData(id: favoriteId)
            favoriteTitleTextField.text = favoriteSpot.title
            favoriteMemoTextView.text = favoriteSpot.memo
            ratingView.rating = favoriteSpot.rating
            settingPoints = [SettingPointEntity]()
            for settingPoint in favoriteSpot.settingPointEntityList {
                settingPoints?.append(settingPoint)
            }
            interestPoint = CLLocationCoordinate2D(latitude: favoriteSpot.latitude, longitude: favoriteSpot.longitude)
        }
    }

    @IBAction private func didTapCloseButton(_ sender: Any) {
        delegate?.closePresentedView()
    }

    @IBAction private func didTapView(_ sender: Any) {
        view.endEditing(true)
    }

    @objc
    private func doneButtonTapped() {
        view.endEditing(true)
    }

    @IBAction private func didTapRegisterButton(_ sender: Any) {
        guard let favoriteTitle = favoriteTitleTextField.text else { return }
        guard let favoriteMemo = favoriteMemoTextView.text else { return }
        guard let interestPoint = interestPoint else { return }
        guard let settingPoints = settingPoints else { return }
        guard let presenter = presenter else { return }

        let tmpFavoriteSpot = FavoriteSpotEntity()
        tmpFavoriteSpot.title = favoriteTitle
        tmpFavoriteSpot.rating = ratingView.rating
        tmpFavoriteSpot.memo = favoriteMemo
        tmpFavoriteSpot.latitude = interestPoint.latitude
        tmpFavoriteSpot.longitude = interestPoint.longitude
        tmpFavoriteSpot.dateTime = Date()

        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()

        if let favoriteId = favoriteId {
            // 更新
            tmpFavoriteSpot.id = favoriteId
            if presenter.registerFavoriteSpot(settingPoints: settingPoints, favoriteSpot: tmpFavoriteSpot) {
                delegate?.closePresentedView()
            }
        } else {
            // 登録
            if presenter.registerFavoriteSpot(settingPoints: settingPoints, favoriteSpot: tmpFavoriteSpot) {
                // Firebaseへイベント送信
                guard let sla = spotListAnalyticsEntity else { return }
                let totalSpotNum = sla.numRestaurantSpot + sla.numHotelSpot + sla.numLeisureSpot + sla.numStationSpot
                let totalTapTimes = sla.timesTappedRestaurantSpot + sla.timesTappedHotelSpot + sla.timesTappedLeisureSpot + sla.timesTappedStationSpot
                Analytics.logEvent(
                    "register_favorite",
                    parameters: [
                        "rating": ratingView.rating as NSObject,
                        "number_of_setting_pin": settingPoints.count as NSObject,
                        "total_number_of_spot": totalSpotNum as NSObject,
                        "number_of_restaurant_spot": sla.numRestaurantSpot as NSObject,
                        "number_of_hotel_spot": sla.numHotelSpot as NSObject,
                        "number_of_leisure_spot": sla.numLeisureSpot as NSObject,
                        "number_of_station_spot": sla.numStationSpot as NSObject,
                        "total_tap_times": totalTapTimes as NSObject,
                        "times_of_restaurant_spot": sla.timesTappedRestaurantSpot as NSObject,
                        "times_of_hotel_spot": sla.timesTappedHotelSpot as NSObject,
                        "times_of_leisure_spot": sla.timesTappedStationSpot as NSObject,
                        "times_of_station_spot": sla.timesTappedStationSpot as NSObject
                    ]
                )

                // 登録完了処理
                delegate?.closePresentedView()
                doneDelegate?.showDoneRegisterView()
            }
        }
        // FireStoreに登録
        let model = FavoriteSpotModel()
        model.addDocument(favoriteSpot: tmpFavoriteSpot)
    }

    private func validateCheck() -> Bool {
        if favoriteTitleTextField.text != "", ratingView.rating != 0.0 {
            return true
        }
        return false
    }

    private func configureRegisterButton() {
        if validateCheck() {
            registerButton.backgroundColor = UIColor(hex: "FA6400")
            registerButton.layer.shadowOpacity = 0.5
            registerButton.layer.shadowRadius = 3
            registerButton.layer.shadowColor = UIColor.gray.cgColor
            registerButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            registerButton.isEnabled = true
        } else {
            registerButton.backgroundColor = UIColor(hex: "FA6400", alpha: 0.3)
            registerButton.layer.shadowOpacity = 0
            registerButton.isEnabled = false
        }
    }
}

extension FavoriteRegisterModalViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension FavoriteRegisterModalViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension FavoriteRegisterModalViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextField = textView
        return true
    }
}

extension FavoriteRegisterModalViewController {
    private func configureNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func handleKeyboardWillShowNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if activeTextField is UITextView {
            let textLimit = favoriteMemoView.frame.maxY + headerHeight + view.frame.height / 10
            let keyboardLimit = super.view.frame.height - keyboardScreenEndFrame.size.height
            if textLimit >= keyboardLimit {
                scrollView.contentOffset.y = textLimit - keyboardLimit + 10
            }
        }
    }

    @objc
    private func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
        configureRegisterButton()
    }
}
