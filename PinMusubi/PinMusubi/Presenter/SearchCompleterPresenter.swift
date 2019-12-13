//
//  SearchCompleterPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit

public protocol SearchCompleterPresenterProtocol: AnyObject {
    init(vc: SearchCompleterViewController, modelType model: InputHistoryModelProtocol.Type)

    func registerInputHistory(inputHistory: InputHistoryEntity)

    func getAllInputHistory()

    func deleteInputHistory(targetInputHistory: InputHistoryEntity) -> Bool

    func deleteAllInputHistory()
}

public class SearchCompleterPresenter: SearchCompleterPresenterProtocol {
    private weak var vc: SearchCompleterViewController?
    private let model: InputHistoryModelProtocol?

    public required init(vc: SearchCompleterViewController, modelType model: InputHistoryModelProtocol.Type) {
        self.vc = vc
        self.model = model.init()
    }

    public func getAllInputHistory() {
        guard let vc = vc else { return }
        guard let model = model else { return }
        let inputHistoryList = model.getAllInputHistory()
        vc.setInputHistoryList(inputHistoryList: inputHistoryList)
    }

    public func registerInputHistory(inputHistory: InputHistoryEntity) {
        guard let model = model else { return }
        if !model.setInputHistory(inputHistory: inputHistory) {
            print("Error --SearchCompleterPresenter#registerInputHistory")
        }
    }

    public func deleteInputHistory(targetInputHistory: InputHistoryEntity) -> Bool {
        guard let model = model else { return false }
        return model.deleteInputHistory(inputHistory: targetInputHistory)
    }

    public func deleteAllInputHistory() {
    }
}
