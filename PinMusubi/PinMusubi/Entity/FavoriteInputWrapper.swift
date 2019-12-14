//
//  FavoriteInputWrapper.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import RealmSwift

public class FavoriteInputWrapper: Object {
    public let favoriteInputList = List<FavoriteInputEntity>()
}
