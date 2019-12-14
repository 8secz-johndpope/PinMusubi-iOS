//
//  RegisterBasePointViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import UIKit

public class RegisterBasePointViewController: UIViewController {
    @IBOutlet private var favoriteNameTextField: UITextField! {
        didSet {
            favoriteNameTextField.becomeFirstResponder()
        }
    }

    private var favoriteBasePoint = FavoriteInputEntity()

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public func setCoordinate(coordinate: CLLocationCoordinate2D) {
        favoriteBasePoint.latitude = coordinate.latitude
        favoriteBasePoint.longitude = coordinate.longitude
    }

    @IBAction private func showFavoriteBasePointView(_ sender: Any) {
        guard let name = favoriteNameTextField.text else { return }
        if name != "" {
            favoriteBasePoint.name = name
            guard let navigationController = navigationController else { return }
            let index = navigationController.viewControllers.count - 3
            guard let favoriteBasePointVC = navigationController.viewControllers[index] as? FavoriteBasePointViewController else { return }
            favoriteBasePointVC.registerFavoriteBasePoint(favoriteBasePoint: favoriteBasePoint)
            navigationController.popToViewController(favoriteBasePointVC, animated: true)
        }
    }
}
