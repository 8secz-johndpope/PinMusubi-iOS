//
//  SettingBasePointsView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import GoogleMobileAds
import MapKit
import UIKit

/// 基準となる地点を設定するView
public class SettingBasePointsView: UIView {
    @IBOutlet private var settingBasePointsScrollView: UIScrollView! {
        didSet {
            settingBasePointsScrollView.delegate = self
        }
    }
    @IBOutlet private var settingBasePointsTableView: UITableView! {
        didSet {
            settingBasePointsTableView.delegate = self
            settingBasePointsTableView.dataSource = self

            for index in 0...cellRow - 1 {
                settingBasePointsTableView.register(UINib(nibName: "SettingBasePointCell", bundle: nil), forCellReuseIdentifier: "SettingBasePointCell" + String(index))
                settingPoints.append(SettingPointEntity())
            }
            settingBasePointsTableView.register(UINib(nibName: "SettingBasePointActionCell", bundle: nil), forCellReuseIdentifier: "SettingBasePointActionCell")
        }
    }

    private var cellRow: Int = 2
    private var editingCell: SettingBasePointCell?
    private var actionCell: SettingBasePointActionCell?
    private var canDoneSettingList = [AddressValidationStatus].init(repeating: .empty, count: 2)
    private var settingPoints = [SettingPointEntity]()
    private var adBannerView = GADBannerView()

    private var presenter: SettingBasePointsPresenterProtocol?

    public weak var delegate: SettingBasePointsViewDelegate?
    public weak var adDelegate: SettingBasePointsViewAdDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()

        presenter = SettingBasePointsPresenter(view: self, modelType: SettingBasePointsModel.self)
        registerKeybordNotification()
    }

    /// Viewタップ時キーボードを閉じる
    /// - Parameter sender: Any
    @IBAction private func didTapView(_ sender: Any) {
        self.endEditing(true)
    }

    @IBAction private func didTapHeader(_ sender: Any) {
        delegate?.moveModalToFull()
    }
    /// 全ての入力値に対する入力チェックを行い、すべて正常であれば設定完了ボタンを活性に切り替え
    private func setActionButton() {
        let canDoneSetting = canDoneSettingList.contains(.empty) || canDoneSettingList.contains(.error)
        guard let actionCell = actionCell else { return }
        // ボタンの状態を戻す
        actionCell.setButtonStatus(maxRow: cellRow)
        // 設定完了ボタンの切り替え
        actionCell.changeDoneSettingStatus(canDoneSetting: !canDoneSetting)
    }
}

/// ScrollViewに関するDelegateメソッド
extension SettingBasePointsView: UIScrollViewDelegate {
    /// スクロールが始まったらキーボードを閉じる
    /// - Parameter scrollView: settingBasePointsScrollView
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}

/// TableViewに関するDelegateメソッド
extension SettingBasePointsView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRow + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellRow != indexPath.row {
            // 設定セルの設定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingBasePointCell" + String(indexPath.row)) as? SettingBasePointCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setPinImage(row: indexPath.row % 10)
            if cellRow - 1 != indexPath.row {
                cell.setBrokenLine()
            }
            return cell
        } else {
            // アクションセルの設定
            guard let cell = settingBasePointsTableView.dequeueReusableCell(withIdentifier: "SettingBasePointActionCell") as? SettingBasePointActionCell else { return UITableViewCell() }
            configureAd()
            cell.delegate = self
            cell.setAdBannerView(adBannerView: adBannerView)
            actionCell = cell
            return cell
        }
    }

    private func configureAd() {
        guard let adMobID = KeyManager().getValue(key: "Ad Mob ID") as? String else { return }
        let adBannerView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        adBannerView.adUnitID = adMobID
        adDelegate?.setRootVC(bannerView: adBannerView)
        adBannerView.load(GADRequest())
        self.adBannerView = adBannerView
    }
}

/// 地点設定セルのDelegateメソッド
extension SettingBasePointsView: SettingBasePointCellDelegate {
    /// 編集中のセルを設定
    /// - Parameter editingCell: 編集中のtextFieldがあるセル
    public func setEditingCell(editingCell: SettingBasePointCell) {
        self.editingCell = editingCell
    }

    /// アクションボタンを隠蔽
    public func hideActionButton() {
        let indexPath = IndexPath(row: cellRow, section: 0)
        guard let actionCell = settingBasePointsTableView.cellForRow(at: indexPath) as? SettingBasePointActionCell else { return }
        actionCell.hideActionButton()
    }

    public func sendEditingCellInstance(inputEditingCell: SettingBasePointCell) {
        editingCell = inputEditingCell
        delegate?.moveModalToFull()
        delegate?.showSearchCompleterView(inputEditingCell: inputEditingCell)
    }

    /// 位置情報の設定
    /// - Parameters:
    ///   - completion: オートコンプリートから選択した位置情報
    ///   - complete: 完了ハンドラ
    public func setCoordinate(completion: MKLocalSearchCompletion?, complete: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = settingBasePointsTableView.indexPath(for: targetCell) else { return }
        if let completion = completion {
            presenter?.getAddress(completion: completion) { coordinate in
                if let coordinate = coordinate {
                    targetCell.setAddress(outputAddress: completion.title)
                    targetCell.setAddressStatus(addressValidationStatus: .success)
                    self.settingPoints[indexPath.row].name = completion.title
                    self.canDoneSettingList[indexPath.row] = .success
                    self.settingPoints[indexPath.row].address = completion.title
                    self.settingPoints[indexPath.row].latitude = coordinate.latitude
                    self.settingPoints[indexPath.row].longitude = coordinate.longitude
                    self.setActionButton()
                } else {
                    targetCell.setAddress(outputAddress: completion.title)
                    targetCell.setAddressStatus(addressValidationStatus: .error)
                    self.canDoneSettingList[indexPath.row] = .error
                    self.setActionButton()
                }
                complete(coordinate)
            }
        } else {
            targetCell.setAddress(outputAddress: "")
            targetCell.setAddressStatus(addressValidationStatus: .empty)
            canDoneSettingList[indexPath.row] = .empty
            setActionButton()
            complete(nil)
        }
    }

    public func setCoordinateFromInputHistory(inputHistory: InputHistoryEntity) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = settingBasePointsTableView.indexPath(for: targetCell) else { return }
        targetCell.setAddress(outputAddress: inputHistory.title)
        targetCell.setAddressStatus(addressValidationStatus: .success)
        self.canDoneSettingList[indexPath.row] = .success
        self.settingPoints[indexPath.row].name = inputHistory.title
        self.settingPoints[indexPath.row].address = inputHistory.title
        self.settingPoints[indexPath.row].latitude = inputHistory.latitude
        self.settingPoints[indexPath.row].longitude = inputHistory.longitude
        self.setActionButton()
    }

    public func setCoordinageFromFavoriteInput(favoriteInput: FavoriteInputEntity) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = settingBasePointsTableView.indexPath(for: targetCell) else { return }
        targetCell.setAddress(outputAddress: favoriteInput.name)
        targetCell.setAddressStatus(addressValidationStatus: .success)
        self.canDoneSettingList[indexPath.row] = .success
        self.settingPoints[indexPath.row].name = favoriteInput.name
        self.settingPoints[indexPath.row].address = favoriteInput.name
        self.settingPoints[indexPath.row].latitude = favoriteInput.latitude
        self.settingPoints[indexPath.row].longitude = favoriteInput.longitude
        self.setActionButton()
    }

    /// 現在地を設定
    /// - Parameter location: 現在地情報
    public func setYourLocation(location: CLLocation) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = settingBasePointsTableView.indexPath(for: targetCell) else { return }
        targetCell.setAddressStatus(addressValidationStatus: .success)
        canDoneSettingList[indexPath.row] = .success
        settingPoints[indexPath.row].name = "現在地"
        settingPoints[indexPath.row].address = "現在地"
        settingPoints[indexPath.row].latitude = location.coordinate.latitude
        settingPoints[indexPath.row].longitude = location.coordinate.longitude
        setActionButton()
    }

    /// 設定地点の名前をセット
    /// - Parameter name: 設定地点の名前
    public func setPointName(name: String) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = settingBasePointsTableView.indexPath(for: targetCell) else { return }
        if !name.isEmpty {
            settingPoints[indexPath.row].name = name
        }
        setActionButton()
    }
}

/// アクションセルのDelegate
extension SettingBasePointsView: SettingBasePointActionCellDelegate {
    /// 追加ボタン押下
    public func addSettingBasePointCell() {
        cellRow += 1
        canDoneSettingList.append(.empty)
        settingPoints.append(SettingPointEntity())
        settingBasePointsTableView.register(UINib(nibName: "SettingBasePointCell", bundle: nil), forCellReuseIdentifier: "SettingBasePointCell" + String(cellRow - 1))
        settingBasePointsTableView.beginUpdates()
        let indexPath = IndexPath(row: cellRow - 1, section: 0)
        settingBasePointsTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        settingBasePointsTableView.endUpdates()
        setActionButton()
    }

    /// 削除ボタン押下
    public func removeSettingBasePointCell() {
        cellRow -= 1
        canDoneSettingList.removeLast()
        settingPoints.removeLast()
        let indexPath = IndexPath(row: cellRow, section: 0)
        guard let searchCriteriaCell = settingBasePointsTableView.cellForRow(at: indexPath) as? SettingBasePointCell else { return }
        searchCriteriaCell.clearTextField()
        settingBasePointsTableView.beginUpdates()
        settingBasePointsTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        settingBasePointsTableView.endUpdates()
        setActionButton()
    }

    /// 設定完了ボタン押下
    public func doneSetting() {
        presenter?.setPointsOnMapView(settingPoints: settingPoints)
    }
}

/// NotificationCenterに関するメソッド
extension SettingBasePointsView {
    private func registerKeybordNotification() {
        let center = NotificationCenter.default

        center.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    /// キーボード表示時、モーダルをスクロール
    /// - Parameter notification: キーボード表示時の通知
    @objc
    private func willShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let editingCell = editingCell else { return }
        // 画面サイズ
        let boundSize: CGSize = UIScreen.main.bounds.size
        // キーボード上部
        guard let keyboardScreenEndFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardLimit: CGFloat = boundSize.height - keyboardScreenEndFrame.size.height
        //セル高さ
        let cellFrame: CGRect = settingBasePointsTableView.convert(editingCell.frame, to: nil)
        let cellLimit: CGFloat = cellFrame.origin.y + cellFrame.height + 8.0

        if cellLimit - keyboardLimit > 0 {
            if let indexPath = settingBasePointsTableView.indexPath(for: editingCell) {
                settingBasePointsTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            }
        }
    }
}
