//
//  FavoriteInputModel.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

/// お気に入り地点に関するModelのProtocol
public protocol FavoriteInputModelProtocol {
    /// コンストラクタ
    init()

    /// お気に入り地点を取得
    func getAllFavoriteInput() -> [FavoriteInputEntity]

    /// お気に入り地点を登録
    func setFavoriteInput(favoriteInput: FavoriteInputEntity)

    /// お気に入り地点を削除
    func deleteFavoriteInput(favoriteInput: FavoriteInputEntity)

    /// お気に入りの順番の入れ替え
    func replaceFavoriteInput(sourceRow: Int, destinationRow: Int)
}

public class FavoriteInputModel: FavoriteInputModelProtocol {
    public required init() {}

    public func getAllFavoriteInput() -> [FavoriteInputEntity] {
        guard let storedFavoriteInputList = FavoriteInputWrapperAccessor().getAll() else { return [FavoriteInputEntity]() }
        var favoriteInputList = [FavoriteInputEntity]()
        for storedFavoriteInput in storedFavoriteInputList {
            favoriteInputList.append(storedFavoriteInput)
        }
        return favoriteInputList
    }

    public func setFavoriteInput(favoriteInput: FavoriteInputEntity) {
        FavoriteInputWrapperAccessor().set(object: favoriteInput)
    }

    public func deleteFavoriteInput(favoriteInput: FavoriteInputEntity) {
        FavoriteInputWrapperAccessor().delete(object: favoriteInput)
    }

    public func replaceFavoriteInput(sourceRow: Int, destinationRow: Int) {
        FavoriteInputWrapperAccessor().replaceRow(sourceRow: sourceRow, destinationRow: destinationRow)
    }
}
