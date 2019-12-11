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
            addressTextField.placeholder = "場所の名前"
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
        }
    }

    private var editingCell: SettingBasePointCell?
    private var sectionCount = 0
    private var initSectionTitles = ["便利機能", "履歴"]
    private var editingSectionTitles = ["候補"]
    private var utilities = ["登録地点から選ぶ", "現在地を設定"]
    private var inputHistorys = [InputPlaceNameHistoryEntity]()
    private var searchCompleter = MKLocalSearchCompleter()

    override public func awakeFromNib() {
        super.awakeFromNib()

        searchCompleter.delegate = self
        sectionCount = initSectionTitles.count
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

    public func setComplete(completion: MKLocalSearchCompletion?) {
        if let completion = completion {
            editingCell?.setAddress(outputAddress: completion.title + ", " + completion.subtitle)
        } else {
            editingCell?.setAddress(outputAddress: "")
        }
        editingCell?.delegate?.validateAddress(completion: completion)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchCompleterViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if addressTextField.text == "" {
            setComplete(completion: nil)
        } else {
            if searchCompleter.results.isEmpty {
                view.endEditing(true)
            } else {
                setComplete(completion: searchCompleter.results[0])
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
                return inputHistorys.count

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
            return UITableViewCell()

        case editingSectionTitles.count:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "suggestionCell")
            let completion = searchCompleter.results[indexPath.row]
            cell.textLabel?.text = completion.title
            cell.detailTextLabel?.text = completion.subtitle
            cell.selectionStyle = .none
            return cell

        default:
            return UITableViewCell()
        }
    }
}

extension SearchCompleterViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionCount {
        case initSectionTitles.count:
            switch indexPath.section {
            case 0:
                print("section:\(indexPath.section)")
                print("row:\(indexPath.row)")

            case 1:
                print("section:\(indexPath.section)")
                print("row:\(indexPath.row)")

            default:
                break
            }

        case editingSectionTitles.count:
            setComplete(completion: searchCompleter.results[indexPath.row])

        default:
            break
        }
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
        print(error)
    }
}
