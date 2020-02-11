//
//  SettingTableViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/10.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SettingTableViewController: UITableViewController {
    private var sectionTitles = [String]()
    private var cellTitles = [[String]]()

    // section
    private var sectionTitle0 = "一般"
    private var sectionTitle1 = "アプリについて"

    // cell
    private var tutorialTitle = "使い方を確認する"
    private var versionTitle = "バージョン"
    private var creditTitle = "クレジット"
    private var contactTitle = "ご意見・ご要望を送る"
    private var reviewTitle = "このアプリを評価する"

    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        sectionTitles = [sectionTitle0, sectionTitle1]
        for _ in sectionTitles {
            cellTitles.append([])
        }
        cellTitles[0] = [tutorialTitle]
        cellTitles[1] = [versionTitle, creditTitle, contactTitle, reviewTitle]
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 1 && indexPath.row == 0 {
            if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.detailTextLabel?.text = version
            }
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        cell.selectionStyle = .none
        cell.textLabel?.text = cellTitles[indexPath.section][indexPath.row]
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellTitle = cellTitles[indexPath.section][indexPath.row]
        if selectedCellTitle == tutorialTitle {
            let tutorialPageVC = TutorialPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
            tutorialPageVC.modalPresentationStyle = .fullScreen
            present(tutorialPageVC, animated: true, completion: nil)
        } else if selectedCellTitle == creditTitle {
            let creditListSV = UIStoryboard(name: "CreditListViewController", bundle: nil)
            guard let creditListVC = creditListSV.instantiateInitialViewController() as? CreditListViewController else { return }
            navigationController?.show(creditListVC, sender: nil)
        } else if selectedCellTitle == contactTitle {
            let contactFormSV = UIStoryboard(name: "ContactFormViewController", bundle: nil)
            guard let contactFormVC = contactFormSV.instantiateInitialViewController() as? ContactFormViewController else { return }
            navigationController?.show(contactFormVC, sender: nil)
        } else if selectedCellTitle == reviewTitle {
            guard let reviewUrl = URL(string: "https://itunes.apple.com/app/id1489074206?action=write-review") else { return }
            UIApplication.shared.open(reviewUrl)
        }
    }
}
