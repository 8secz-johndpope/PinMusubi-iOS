//
//  TutorialCollectionViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/21.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class TutorialCollectionViewController: UICollectionViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionView.decelerationRate = .fast
        guard let flowLayout = collectionViewLayout as? CustomFlowLayout else { return }
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    override public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 5
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath) as? TutorialCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(row: indexPath.row)
        return cell
    }

    override public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case "UICollectionElementKindSectionHeader":
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TutorialHeader", for: indexPath)
            return header
        case "UICollectionElementKindSectionFooter":
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "TutorialFooter",
                for: indexPath
                ) as? TutorialFooterView else { return UICollectionReusableView() }
            footer.delegate = self
            return footer

        default:
            return UICollectionReusableView()
        }
    }
}

extension TutorialCollectionViewController: UICollectionViewDelegateFlowLayout {
    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        (collectionView.collectionViewLayout as? CustomFlowLayout)?.prepareForPaging()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.9, height: collectionView.bounds.height * 0.9)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8, height: collectionView.bounds.height)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8, height: collectionView.bounds.height)
    }
}

extension TutorialCollectionViewController: TutorialFooterDelegate {
    public func closeTutorialView() {
        dismiss(animated: true, completion: nil)
    }
}
