//
//  FavoriteBasePointViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

public class FavoriteBasePointViewController: UIViewController {
    @IBOutlet private var showRegisterBasePointViewButton: UIButton! {
        didSet {
            showRegisterBasePointViewButton.backgroundColor = UIColor(hex: "FA6400")
            showRegisterBasePointViewButton.layer.cornerRadius = 10
        }
    }

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

        let editButtonItem = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(changeEditMode))
        navigationItem.rightBarButtonItem = editButtonItem

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

    @objc
    private func changeEditMode() {
        if favoriteBasePointTableView.isEditing {
            favoriteBasePointTableView.setEditing(false, animated: true)
            let editButtonItem = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(changeEditMode))
            navigationItem.rightBarButtonItem = editButtonItem
        } else {
            favoriteBasePointTableView.setEditing(true, animated: true)
            let editButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(changeEditMode))
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }

    public func registerFavoriteBasePoint(favoriteBasePoint: FavoriteInputEntity) {
        presenter?.registerFavoriteInput(favoriteInput: favoriteBasePoint)
        presenter?.getAllFavoriteInput()
        favoriteBasePointTableView.reloadData()
    }
}

extension FavoriteBasePointViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "登録場所一覧"
    }

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

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteFavoriteInput(targetFavoriteInput: favoriteBasePointList[indexPath.row])
            presenter?.getAllFavoriteInput()
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter?.replaceFavoriteInput(sourceRow: sourceIndexPath.row, destinationRow: destinationIndexPath.row)
        presenter?.getAllFavoriteInput()
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
}
