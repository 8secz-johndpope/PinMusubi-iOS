//
//  SearchCompleterViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/09.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class SearchCompleterViewController: UIViewController {
    @IBOutlet private var inputTextView: UIView! {
        didSet {
            inputTextView.layer.cornerRadius = 8
        }
    }

    @IBOutlet private var addressTextField: UITextField! {
        didSet {
            addressTextField.delegate = self
            addressTextField.becomeFirstResponder()
            addressTextField.returnKeyType = .done
            addressTextField.clearButtonMode = .whileEditing
            addressTextField.placeholder = "場所を検索"
            addressTextField.text = editingCell?.getAddress()
        }
    }

    @IBOutlet private var placeSuggestScrollView: UIScrollView! {
        didSet {
            placeSuggestScrollView.delegate = self
        }
    }

    @IBOutlet private var placeNameSuggestionTableView: UITableView! {
        didSet {
            placeNameSuggestionTableView.delegate = self
            placeNameSuggestionTableView.dataSource = self
            placeNameSuggestionTableView.tableFooterView = UIView()
        }
    }

    private var editingCell: SettingBasePointCell?
    private var sectionCount = 0
    private var initSectionTitles = ["便利機能", "検索履歴"]
    private var editingSectionTitles = ["候補"]
    private var utilities = ["現在地を設定", "登録地点から選ぶ"]
    private var inputHistories = [InputHistoryEntity]()
    private var searchCompleter = MKLocalSearchCompleter()
    private var locationManager: CLLocationManager?

    public var presenter: SearchCompleterPresenter?

    override public func awakeFromNib() {
        super.awakeFromNib()

        searchCompleter.delegate = self
        sectionCount = initSectionTitles.count

        presenter = SearchCompleterPresenter(vc: self, modelType: InputHistoryModel.self)
        presenter?.getAllInputHistory()
    }

    public func setInputEditingCellInstance(inputEditingCell: SettingBasePointCell) {
        editingCell = inputEditingCell
    }

    @IBAction private func didTappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        guard let address = addressTextField.text else { return }
        if address.isEmpty {
            sectionCount = initSectionTitles.count
            placeNameSuggestionTableView.reloadData()
        } else {
            guard let address = addressTextField.text else { return }
            searchCompleter.queryFragment = address
        }
    }

    public func setCompletion(completion: MKLocalSearchCompletion?) {
        editingCell?.delegate?.setCoordinate(completion: completion) { coordinate in
            if let completion = completion, let coordinate = coordinate {
                let inputHistory = InputHistoryEntity()
                inputHistory.title = completion.title
                inputHistory.subtitle = completion.subtitle
                inputHistory.latitude = coordinate.latitude
                inputHistory.longitude = coordinate.longitude
                self.presenter?.registerInputHistory(inputHistory: inputHistory)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    public func setInputHistoryList(inputHistoryList: [InputHistoryEntity]) {
        inputHistories = inputHistoryList
    }
}

extension SearchCompleterViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if addressTextField.text == "" {
            setCompletion(completion: nil)
        } else {
            if searchCompleter.results.isEmpty {
                view.endEditing(true)
            } else {
                setCompletion(completion: searchCompleter.results[0])
            }
        }
        return true
    }
}

extension SearchCompleterViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SearchCompleterViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sectionCount {
        case initSectionTitles.count:
            return initSectionTitles[section]

        case editingSectionTitles.count:
            return editingSectionTitles[section]

        default:
            return ""
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionCount == initSectionTitles.count {
            switch section {
            case 0:
                return utilities.count

            case 1:
                return inputHistories.count

            default:
                return 0
            }
        } else {
            return searchCompleter.results.count
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionCount {
        case initSectionTitles.count:
            switch indexPath.section {
            case 0:
                let cell = UITableViewCell(style: .default, reuseIdentifier: "utilityCell")
                cell.textLabel?.text = utilities[indexPath.row]
                cell.imageView?.image = UIImage(named: "Utility\(indexPath.row)")
                return cell

            case 1:
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "inputHistoryCell")
                cell.textLabel?.text = inputHistories[indexPath.row].title
                cell.detailTextLabel?.text = inputHistories[indexPath.row].subtitle
                return cell

            default:
                return UITableViewCell()
            }

        case editingSectionTitles.count:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "suggestionCell")
            let completion = searchCompleter.results[indexPath.row]
            cell.textLabel?.text = completion.title
            cell.detailTextLabel?.text = completion.subtitle
            return cell

        default:
            return UITableViewCell()
        }
    }
}

extension SearchCompleterViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sectionCount == initSectionTitles.count && indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if presenter?.deleteInputHistory(targetInputHistory: inputHistories[indexPath.row]) ?? false {
                presenter?.getAllInputHistory()
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionCount {
        case initSectionTitles.count:
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    setupLocationManager()

                case 1:
                    let favoriteBasePointView = UIStoryboard(name: "FavoriteBasePointViewController", bundle: nil)
                    guard let favoriteBasePointVC = favoriteBasePointView.instantiateInitialViewController() as? FavoriteBasePointViewController else { return }
                    guard let editingCell = editingCell else { return }
                    favoriteBasePointVC.setInputEditingCellInstance(inputEditingCell: editingCell)
                    navigationController?.show(favoriteBasePointVC, sender: nil)

                default:
                    break
                }

            case 1:
                editingCell?.delegate?.setCoordinateFromInputHistory(inputHistory: inputHistories[indexPath.row])
                presenter?.registerInputHistory(inputHistory: inputHistories[indexPath.row])
                dismiss(animated: true, completion: nil)

            default:
                break
            }

        case editingSectionTitles.count:
            setCompletion(completion: searchCompleter.results[indexPath.row])

        default:
            break
        }

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

extension SearchCompleterViewController: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let address = addressTextField.text else { return }
        if !address.isEmpty {
            sectionCount = editingSectionTitles.count
            placeNameSuggestionTableView.reloadData()
        }
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        var failedGetYourLocationAlert = UIAlertController()
        failedGetYourLocationAlert = UIAlertController(
            title: "場所の候補を取得することができませんでした",
            message: "インターネット接続を確認してください",
            preferredStyle: .alert
        )
        failedGetYourLocationAlert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(failedGetYourLocationAlert, animated: true)
    }
}

extension SearchCompleterViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            break

        case .denied:
            var failedGetYourLocationAlert = UIAlertController()
            failedGetYourLocationAlert = UIAlertController(
                title: "現在地を取得できません",
                message: "設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい",
                preferredStyle: .alert
            )
            failedGetYourLocationAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil
                )
            )
            present(failedGetYourLocationAlert, animated: true)

        case .restricted:
            break

        case .authorizedAlways:
            break

        case .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let yourLocation = locations.first else { return }
        editingCell?.setAddress(outputAddress: "現在地")
        editingCell?.delegate?.setYourLocation(location: yourLocation)
        locationManager?.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        var failedGetYourLocationAlert = UIAlertController()
        failedGetYourLocationAlert = UIAlertController(
            title: "現在地を取得することができませんでした",
            message: "インターネット接続を確認してください",
            preferredStyle: .alert
        )
        failedGetYourLocationAlert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(failedGetYourLocationAlert, animated: true)
    }
}
