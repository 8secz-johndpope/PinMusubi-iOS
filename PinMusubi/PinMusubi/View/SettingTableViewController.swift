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

    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        sectionTitles = ["一般", "アプリについて"]
        for _ in sectionTitles {
            cellTitles.append([])
        }
        cellTitles[0] = ["チュートリアルを見る"]
        cellTitles[1] = ["バージョン", "クレジット", "ご意見・ご要望はこちら", "このアプリを評価する"]
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
}
