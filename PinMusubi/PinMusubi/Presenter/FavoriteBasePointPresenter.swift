//
//  FavoriteBasePointPresenter.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/14.
//  Copyright © 2019 naipaka. All rights reserved.
//

public protocol FavoriteBasePointPresenterProtocol: AnyObject {
    init(vc: FavoriteBasePointViewController, modelType model: FavoriteInputModelProtocol.Type)

    func getAllFavoriteInput()

    func registerFavoriteInput(favoriteInput: FavoriteInputEntity)

    func deleteFavoriteInput(targetFavoriteInput: FavoriteInputEntity)

    func replaceFavoriteInput(sourceRow: Int, destinationRow: Int)
}

public class FavoriteBasePointPresenter: FavoriteBasePointPresenterProtocol {
    private weak var vc: FavoriteBasePointViewController?
    private let model: FavoriteInputModelProtocol?

    public required init(vc: FavoriteBasePointViewController, modelType model: FavoriteInputModelProtocol.Type) {
        self.vc = vc
        self.model = model.init()
    }

    public func getAllFavoriteInput() {
        guard let vc = vc else { return }
        guard let model = model else { return }
        let favoriteInputList = model.getAllFavoriteInput()
        vc.setFavoriteInputList(favoriteInputList: favoriteInputList)
    }

    public func registerFavoriteInput(favoriteInput: FavoriteInputEntity) {
        guard let model = model else { return }
        model.setFavoriteInput(favoriteInput: favoriteInput)
    }

    public func deleteFavoriteInput(targetFavoriteInput: FavoriteInputEntity) {
        guard let model = model else { return }
        model.deleteFavoriteInput(favoriteInput: targetFavoriteInput)
    }

    public func replaceFavoriteInput(sourceRow: Int, destinationRow: Int) {
        guard let model = model else { return }
        model.replaceFavoriteInput(sourceRow: sourceRow, destinationRow: destinationRow)
    }
}
