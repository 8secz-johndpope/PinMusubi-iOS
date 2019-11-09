//
//  MyPageViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/11/05.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class MyPageViewController: UIViewController {
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var collectionView: MyPageCollectionView!

    private var flowLayout: CustomFlowLayout?
    private var isChangeSegmentedControl: Bool = true

    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false

        configureUI()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    private func configureUI() {
        segmentedControl.setTitle("お気に入り", forSegmentAt: 0)
        segmentedControl.setTitle("検索履歴", forSegmentAt: 1)
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor(hex: "FA6400")
        } else {
            segmentedControl.tintColor = UIColor(hex: "FA6400")
        }
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "FA6400")], for: .normal)
        segmentedControl.layer.borderColor = UIColor(hex: "FA6400").cgColor
        segmentedControl.layer.borderWidth = 1.0
    }

    @IBAction private func didChangeSegment(_ sender: Any) {
        isChangeSegmentedControl = false
        let selectedIndex = segmentedControl.selectedSegmentIndex
        flowLayout?.slideView(selectedSegmentIndex: selectedIndex)
    }
}

extension MyPageViewController: UICollectionViewDelegate {}

extension MyPageViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return segmentedControl.numberOfSegments
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        flowLayout = collectionView.collectionViewLayout as? CustomFlowLayout
        flowLayout?.prepareForPaging()
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPageCollectionViewCell", for: indexPath)
            as? MyPageCollectionViewCell else { return MyPageCollectionViewCell() }
        if indexPath.row == 0 {
            cell.configre(myDataType: .favorite)
        } else if indexPath.row == 1 {
            cell.configre(myDataType: .history)
        }
        cell.delegate = self
        return cell
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isChangeSegmentedControl = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isChangeSegmentedControl {
            let offSet = scrollView.contentOffset.x
            let collectionWidth = scrollView.bounds.width / 2
            segmentedControl.selectedSegmentIndex = Int(offSet / collectionWidth)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

extension MyPageViewController: MyPageCollectionViewCellDelegate {
    public func showSpotDetailsView(myData: MyDataEntityProtocol) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let myDetailsDataSV = UIStoryboard(name: "MyDetailsDataViewController", bundle: nil)
            guard let myDetailsDataVC = myDetailsDataSV.instantiateInitialViewController() as? MyDetailsDataViewController else { return }
            myDetailsDataVC.setParameter(myData: myData)
            navigationController?.show(myDetailsDataVC, sender: nil)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let actionMenu = UIAlertController()
            let moveAction = UIAlertAction(title: "MAPで確認する", style: .default, handler: { (_: UIAlertAction) -> Void in
                print("move")
            }
            )
            let deleteAction = UIAlertAction(title: "履歴から削除する", style: .destructive, handler: { (_: UIAlertAction) -> Void in
                self.deleteHistoryData(myData: myData)
            }
            )
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            actionMenu.addAction(moveAction)
            actionMenu.addAction(deleteAction)
            actionMenu.addAction(cancelAction)
            present(actionMenu, animated: true, completion: nil)
        }
    }

    private func deleteHistoryData(myData: MyDataEntityProtocol) {
        guard let historyData = myData as? SearchHistoryEntity else { return }
        let model = MyDataModel()
        if model.deleteHistoryData(id: historyData.id) {
            collectionView.reloadData()
        }
    }
}
