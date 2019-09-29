//
//  SearchCriteriaCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

/// 検索条件セルのDelegate
public protocol SearchCriteriaCellDelegate: AnyObject {
    /// 検索条件セルを編集中セルに設定
    func setEditingCell(editingCell: UITableViewCell)
    /// 追加・削除・設定完了ボタンを隠蔽
    func hideActionButton()
}

public extension SearchCriteriaCellDelegate {
    /// TableView更新
    func validateAddress() {}
}
