//
//  ModalContentView.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/18.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class ModalContentView: UIView, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SearchCriteriaActionDelegate {
    @IBOutlet private var searchCriteriaScrollView: UIScrollView!
    @IBOutlet private var searchCriteriaTableView: UITableView!
    private var editingTextFieldView = UIView()
    private var pointNameTextField: UITextField?
    private var addressTextField: UITextField?
    private var cells = [SearchCriteriaCell]()
    private var cellRow: Int = 2
    private var canDoneSetting: Bool = false
    private var addressStatus = [String].init(repeating: "empty", count: 2)

    private var presenter: SearchCriteriaViewPresenterProtocol?

    public weak var delegate: ModalContentViewDelegate?

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.presenter = SearchCriteriaViewPresenter(view: self, modelType: SearchCriteriaModel.self)
        // tableViewにcellを登録
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaCell")
        searchCriteriaTableView.register(UINib(nibName: "SearchCriteriaActionCell", bundle: nil), forCellReuseIdentifier: "SearchCriteriaActionCell")
        // delegateの設定
        searchCriteriaTableView.delegate = self
        searchCriteriaTableView.dataSource = self
        searchCriteriaScrollView.delegate = self
        // 通知設定登録
        registerNotification()
    }

    @IBAction private func didTapView(_ sender: Any) {
        self.endEditing(true)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellRow + 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellRow != indexPath.row {
            // 検索条件セルの設定
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCriteriaCell") as? SearchCriteriaCell else { return UITableViewCell() }
            cell.setPinOnModal(row: indexPath.row % 10)
            if cellRow - 1 != indexPath.row { cell.setBrokenLine() }
            (pointNameTextField, addressTextField) = cell.getTextFields()
            cell.setAddressStatus(inputStatus: addressStatus[indexPath.row])
            pointNameTextField?.delegate = self
            addressTextField?.delegate = self
            cells.append(cell)
            return cell
        } else {
            // actionCellを設定
            guard let cell = searchCriteriaTableView.dequeueReusableCell(withIdentifier: "SearchCriteriaActionCell") as? SearchCriteriaActionCell else { return UITableViewCell() }
            if cellRow == 2 {
                cell.hideRemoveButton()
            } else {
                cell.appearRemoveButton()
            }
            checkInput()
            cell.changeDoneSettingStatus(canDoneSetting: canDoneSetting && !addressStatus.contains("error"))
            cell.delegate = self
            return cell
        }
    }

    public func addSearchCriteriaCell() {
        cellRow += 1
        cells = [SearchCriteriaCell]()
        addressStatus.append("empty")
        searchCriteriaTableView.reloadData()
    }

    public func removeSearchCriteriaCell() {
        cellRow -= 1
        cells = [SearchCriteriaCell]()
        addressStatus.removeLast()
        searchCriteriaTableView.reloadData()
    }

    public func doneSetting() {
        presenter?.setPointsOnMap()
    }

    private func checkInput() {
        // 入力チェック
        for cell in cells {
            if !cell.checkRequired() {
                canDoneSetting = false
                return
            }
        }
        // actionCellの更新
        canDoneSetting = true
    }

    public func setMessage(canDone: Bool, row: Int) {
        if cells[row].checkAddress() {
            if canDone {
                addressStatus[row] = "success"
            } else {
                addressStatus[row] = "error"
            }
        } else {
            addressStatus[row] = "empty"
        }
        searchCriteriaTableView.reloadData()
    }
}

extension ModalContentView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let superView = textField.superview else { return }
        editingTextFieldView = superView
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension ModalContentView {
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
        if let userInfo = notification.userInfo,
            let tableView = searchCriteriaTableView,
            let cell = editingTextFieldView.superview?.superview as? SearchCriteriaCell {
            // 画面サイズ
            let boundSize: CGSize = UIScreen.main.bounds.size
            // キーボード上部
            guard let keyboardScreenEndFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            let keyboardLimit: CGFloat = boundSize.height - keyboardScreenEndFrame.size.height
            //セル高さ
            let cellFrame: CGRect = tableView.convert(cell.frame, to: nil)
            let cellLimit: CGFloat = cellFrame.origin.y + cellFrame.height + 8.0

            if cellLimit - keyboardLimit > 0 {
                if let indexPath = tableView.indexPath(for: cell) {
                    tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
    }

    @objc
    private func didHideKeboard(_ notification: Notification) {
        for index in 0...cellRow - 1 {
            guard let inputName = cells[index].getTextFields().0.text else { return }
            guard let inputAddress = cells[index].getTextFields().1.text else { return }
            presenter?.convertingToCoordinate(name: inputName, address: inputAddress, row: index)
        }
        searchCriteriaTableView.reloadData()
    }
}
