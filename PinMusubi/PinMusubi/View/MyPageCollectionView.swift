//
//  MyPageCollectionView.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class MyPageCollectionView: UICollectionView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.decelerationRate = .fast

        guard let flowLayout = collectionViewLayout as? CustomFlowLayout else { return }
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1_000)
    }
}
