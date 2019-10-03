//
//  SearchCriteriaActionDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/09/22.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// 処理を地点設定Viewに委譲するdelegate
public protocol SettingBasePointActionCellDelegate: AnyObject {
    /// 追加ボタン押下時
    func addSettingBasePointCell()
    /// 削除ボタン押下時
    func removeSettingBasePointCell()
    /// 設定完了ボタン押下時
    func doneSetting()
}
