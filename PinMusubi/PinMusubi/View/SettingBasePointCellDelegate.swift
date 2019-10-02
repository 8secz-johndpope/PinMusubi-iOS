//
//  SettingBasePointCellDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/29.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// 検索条件セルのDelegate
public protocol SettingBasePointCellDelegate: AnyObject {
    /// 検索条件セルを編集中セルに設定
    /// - Parameter editingCell: 編集中のセル
    func setEditingCell(editingCell: SettingBasePointCell)
    /// 追加・削除・設定完了ボタンを隠蔽
    func hideActionButton()
    /// 住所のチェック
    /// - Parameter address: 入力された住所
    func validateAddress(address: String)
    /// 地点名を設定
    /// - Parameter name: 入力された地点名
    func setPointName(name: String)
}
