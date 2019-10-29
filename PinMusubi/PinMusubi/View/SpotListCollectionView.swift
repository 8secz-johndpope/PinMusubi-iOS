//
//  SpotListCollectionView.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class SpotListCollectionView: UICollectionView {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.decelerationRate = .fast

        guard let flowLayout = collectionViewLayout as? FlowLayout else { return }
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 40)
    }
}
