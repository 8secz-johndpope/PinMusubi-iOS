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
        flowLayout.itemSize = bounds.size
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
    }
}
