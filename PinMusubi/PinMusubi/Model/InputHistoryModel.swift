//
//  InputHistoryModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

/// 入力履歴に関するModelのProtocol
public protocol InputHistoryModelProtocol {
    /// コンストラクタ
    init()

    /// 入力履歴を取得
    func getAllInputHistory() -> [InputHistoryEntity]

    /// 入力履歴を登録
    func setInputHistory(inputKeyword: String) -> Bool

    /// 入力履歴を削除
    func deleteInputHistory(inputHistory: InputHistoryEntity) -> Bool

    /// 入力履歴を全削除
    func deleteAllInputHistory()
}

public class InputHistoryModel: InputHistoryModelProtocol {
    public required init() {}

    public func getAllInputHistory() -> [InputHistoryEntity] {
        var inputHistoryList = [InputHistoryEntity]()
        if let resultList = InputHistoryAccessor().getAll() {
            for result in resultList {
                inputHistoryList.append(result)
            }
        }
        return inputHistoryList
    }

    public func setInputHistory(inputKeyword: String) -> Bool {
        let inputHistoryAccessor = InputHistoryAccessor()
        guard let storedInputHistoryList = inputHistoryAccessor.getAll() else { return false }
        if storedInputHistoryList.count > 19 {
            guard let storedInputHistoryLast = storedInputHistoryList.last else { return false }
            if !inputHistoryAccessor.delete(data: storedInputHistoryLast) {
                print("Error --InputHistoryModel#setInputHistory")
            }
        }
        let inputHistory = InputHistoryEntity()
        inputHistory.keyword = inputKeyword
        return inputHistoryAccessor.set(data: inputHistory)
    }

    public func deleteInputHistory(inputHistory: InputHistoryEntity) -> Bool {
        return InputHistoryAccessor().delete(data: inputHistory)
    }

    public func deleteAllInputHistory() {
        InputHistoryAccessor().deleteAll()
    }
}
