//
//  FavoriteBasePointViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class FavoriteBasePointViewController: UIViewController {
    @IBOutlet private var showRegisterBasePointViewButton: UIButton!

    @IBOutlet private var favoriteBasePointTableView: UITableView! {
        didSet {
            favoriteBasePointTableView.delegate = self
            favoriteBasePointTableView.dataSource = self
            favoriteBasePointTableView.tableFooterView = UIView()
        }
    }

    private var editingCell = SettingBasePointCell()
    private var favoriteBasePointList = [FavoriteInputEntity]()

    public var presenter: FavoriteBasePointPresenter?

    override public func viewDidLoad() {
        super.viewDidLoad()

        presenter = FavoriteBasePointPresenter(vc: self, modelType: FavoriteInputModel.self)
        presenter?.getAllFavoriteInput()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    public func setInputEditingCellInstance(inputEditingCell: SettingBasePointCell) {
        editingCell = inputEditingCell
    }

    public func setFavoriteInputList(favoriteInputList: [FavoriteInputEntity]) {
        favoriteBasePointList = favoriteInputList
    }

    @IBAction private func showRegisterBasePointView(_ sender: Any) {
        let searchBasePointView = UIStoryboard(name: "SearchBasePointViewController", bundle: nil)
        guard let searchBasePointVC = searchBasePointView.instantiateInitialViewController() as? SearchBasePointViewController else { return }
        navigationController?.show(searchBasePointVC, sender: nil)
    }

    public func reloadFavoriteBasePointTableView() {
        presenter?.getAllFavoriteInput()
        favoriteBasePointTableView.reloadData()
    }
}

extension FavoriteBasePointViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBasePointList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = favoriteBasePointList[indexPath.row].name
        return cell
    }
}

extension FavoriteBasePointViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editingCell.delegate?.setCoordinageFromFavoriteInput(favoriteInput: favoriteBasePointList[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
