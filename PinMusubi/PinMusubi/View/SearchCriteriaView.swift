//
//  SearchCriteriaView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class SearchCriteriaView: UIView {
    @IBOutlet private var searchCriteriaScrollView: UIScrollView!
    @IBOutlet private var searchCriteriaTableView: UITableView!

    private var cellRow: Int = 2
    private var editingCell: SearchCriteriaCell?
    private var actionCell: SearchCriteriaActionCell?
    private var canDoneSettingList = [AddressValidationStatus].init(repeating: .empty, count: 2)
    private var settingPoints = [SettingPointEntity]()

    private var presenter: SearchCriteriaViewPresenterProtocol?

    public weak var delegate: SearchCriteriaViewDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        // delegateの設定
        searchCriteriaScrollView.delegate = self
        searchCriteriaTableView.delegate = self
        searchCriteriaTableView.dataSource = self
        // presenterの設定
        self.presenter = SearchCriteriaViewPresenter(view: self, modelType: SearchCriteriaModel.self)
        // tableViewにcellを登録
        for index in 0...cellRow - 1 {
            searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaCell" + String(index))
            settingPoints.append(SettingPointEntity())
        }
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaActionCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaActionCell")
        // 通知設定登録
        registerNotification()
    }

    @IBAction private func didTapView(_ sender: Any) {
        self.endEditing(true)
    }

    /// 全ての入力値に対する入力チェック
    private func setActionButton() {
        let canDoneSetting = canDoneSettingList.contains(.empty) || canDoneSettingList.contains(.error)
        guard let actionCell = actionCell else { return }
        actionCell.setButtonStatus(maxRow: cellRow)
        actionCell.changeDoneSettingStatus(canDoneSetting: !canDoneSetting)
    }
}

/// ScrollViewに関するDelegateメソッド
extension SearchCriteriaView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}

/// TableViewに関するDelegateメソッド
extension SearchCriteriaView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRow + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellRow != indexPath.row {
            // 検索条件セルの設定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCriteriaCell" + String(indexPath.row)) as? SearchCriteriaCell else { return UITableViewCell() }
            cell.delegate = self
            if cellRow - 1 != indexPath.row { cell.setBrokenLine() }
            cell.setPinOnModal(row: indexPath.row % 10)
            return cell
        } else {
            // actionCellを設定
            guard let cell = searchCriteriaTableView.dequeueReusableCell(withIdentifier: "SearchCriteriaActionCell") as? SearchCriteriaActionCell else { return UITableViewCell() }
            cell.delegate = self
            actionCell = cell
            return cell
        }
    }
}

/// 検索条件セルのDelegateメソッド
extension SearchCriteriaView: SearchCriteriaCellDelegate {
    /// 編集中のセルを設定
    /// - Parameter editingCell: 編集中のtextFieldがあるセル
    public func setEditingCell(editingCell: SearchCriteriaCell) {
        self.editingCell = editingCell
    }

    /// アクションボタンを隠蔽
    public func hideActionButton() {
        let indexPath = IndexPath(row: cellRow, section: 0)
        guard let actionCell = searchCriteriaTableView.cellForRow(at: indexPath) as? SearchCriteriaActionCell else { return }
        actionCell.hideActionButton()
    }

    /// 住所の入力チェック
    /// - Parameter address: 住所の入力情報
    public func validateAddress(address: String) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = searchCriteriaTableView.indexPath(for: targetCell) else { return }
        if address == "" {
            targetCell.setAddressStatus(addressValidationStatus: .empty)
            self.canDoneSettingList[indexPath.row] = .empty
        } else {
            presenter?.validateAddress(address: address, complete: {settingPoint, status in
                targetCell.setAddressStatus(addressValidationStatus: status)
                self.canDoneSettingList[indexPath.row] = status
                self.settingPoints[indexPath.row].address = settingPoint.address
                self.settingPoints[indexPath.row].latitude = settingPoint.latitude
                self.settingPoints[indexPath.row].longitude = settingPoint.longitude
            }
            )
        }
    }

    /// 設定地点の名前をセット
    /// - Parameter name: 設定地点の名前
    public func setPointName(name: String) {
        guard let targetCell = editingCell else { return }
        guard let indexPath = searchCriteriaTableView.indexPath(for: targetCell) else { return }
        settingPoints[indexPath.row].name = name
    }
}

extension SearchCriteriaView: SearchCriteriaActionDelegate {
    public func addSearchCriteriaCell() {
        cellRow += 1
        canDoneSettingList.append(.empty)
        settingPoints.append(SettingPointEntity())
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaCell" + String(cellRow - 1))
        searchCriteriaTableView.beginUpdates()
        let indexPath = IndexPath(row: cellRow - 1, section: 0)
        searchCriteriaTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        searchCriteriaTableView.endUpdates()
        setActionButton()
    }

    public func removeSearchCriteriaCell() {
        cellRow -= 1
        canDoneSettingList.removeLast()
        settingPoints.removeLast()
        let indexPath = IndexPath(row: cellRow, section: 0)
        guard let searchCriteriaCell = searchCriteriaTableView.cellForRow(at: indexPath) as? SearchCriteriaCell else { return }
        searchCriteriaCell.clearTextField()
        searchCriteriaTableView.beginUpdates()
        searchCriteriaTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        searchCriteriaTableView.endUpdates()
        setActionButton()
    }

    public func doneSetting() {
        presenter?.setPointsOnMapView(settingPoints: settingPoints)
    }
}

/// NotificationCenterに関するメソッド
extension SearchCriteriaView {
    private func registerNotification() {
        let center = NotificationCenter.default

        center.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        center.addObserver(
            self,
            selector: #selector(self.didHideKeboard(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }

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
        let cellFrame: CGRect = searchCriteriaTableView.convert(editingCell.frame, to: nil)
        let cellLimit: CGFloat = cellFrame.origin.y + cellFrame.height + 8.0

        if cellLimit - keyboardLimit > 0 {
            if let indexPath = searchCriteriaTableView.indexPath(for: editingCell) {
                searchCriteriaTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            }
        }
    }

    @objc
    private func didHideKeboard(_ notification: Notification) {
        setActionButton()
    }
}
