//
//  FlowLayout.swift
//  PinMusubi
//
//  Created by rMac on 2019/10/28.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class CustomFlowLayout: UICollectionViewFlowLayout {
    private var layoutAttributesForPaging: [UICollectionViewLayoutAttributes]?

    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        guard let targetAttributes = layoutAttributesForPaging else { return proposedContentOffset }

        let nextAttributes: UICollectionViewLayoutAttributes?
        if velocity.x == 0 {
            nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            nextAttributes = targetAttributes.last
        } else {
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }
        let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
        return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: (attributes.frame.maxY - attributes.frame.minY) / 2)
    }

    private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
            let distance = attributes.frame.midX - screenCenterX
            return abs(distance) < abs(result.distance) ? (attributes, distance) : result
        }
        return result.attributes
    }

    public func prepareForPaging() {
        guard let collectionView = collectionView else { return }
        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(
            x: collectionView.contentOffset.x - expansionMargin,
            y: 0,
            width: collectionView.bounds.width + (expansionMargin * 2),
            height: collectionView.bounds.height
        )
        layoutAttributesForPaging = layoutAttributesForElements(in: expandedVisibleRect)?.sorted { $0.frame.minX < $1.frame.minX }
    }

    public func slideView(selectedSegmentIndex: Int) {
        guard let collectionView = collectionView else { return }
        collectionView.scrollToItem(at: IndexPath(row: selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}
