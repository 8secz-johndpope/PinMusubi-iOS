//
//  SearchBasePointViewController.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/13.
//  Copyright © 2019 naipaka. All rights reserved.
//

import MapKit
import UIKit

public class SearchBasePointViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    @IBOutlet private var addressView: UIView! {
        didSet {
            addressView.layer.cornerRadius = 8
            addressView.layer.shadowOffset = CGSize(width: 0, height: 0)
            addressView.layer.shadowColor = UIColor.gray.cgColor
            addressView.layer.shadowRadius = 4.0
            addressView.layer.shadowOpacity = 0.6
        }
    }

    @IBOutlet private var addressTextField: UITextField! {
        didSet {
            addressTextField.delegate = self
            addressTextField.becomeFirstResponder()
            addressTextField.returnKeyType = .done
            addressTextField.clearButtonMode = .whileEditing
            addressTextField.placeholder = "場所を検索"
        }
    }

    @IBOutlet private var backGroundView: UIView! {
        didSet {
            backGroundView.isHidden = true
        }
    }

    @IBOutlet private var completerScrollView: UIScrollView! {
        didSet {
            completerScrollView.isHidden = true
            completerScrollView.delegate = self
        }
    }

    @IBOutlet private var completerTableView: UITableView! {
        didSet {
            completerTableView.isHidden = true
            completerTableView.delegate = self
            completerTableView.dataSource = self
            completerTableView.tableFooterView = UIView()
        }
    }

    private var annotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        return annotation
    }()

    private var searchCompleter = MKLocalSearchCompleter()
    private var selectedCoordinate = CLLocationCoordinate2D()

    override public func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self

        let myLongPress = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(dropPin(sender:)))

        mapView.addGestureRecognizer(myLongPress)
    }

    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        guard let address = addressTextField.text else { return }
        backGroundView.isHidden = address.isEmpty
        completerScrollView.isHidden = address.isEmpty
        completerTableView.isHidden = address.isEmpty
        if !address.isEmpty {
            searchCompleter.queryFragment = address
        }
    }

    private func setPinOnMap(coordinate: CLLocationCoordinate2D) {
        selectedCoordinate = coordinate

        mapView.removeAnnotation(annotation)
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "ここを登録する"
        mapView.addAnnotation(annotation)

        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        mapView.setCenter(center, animated: true)

        mapView.selectAnnotation(annotation, animated: true)
    }

    @objc
    private func dropPin(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            setPinOnMap(coordinate: coordinate)
        }
        return
    }

    private func setCompletion(completion: MKLocalSearchCompletion) {
        SettingBasePointsModel().geocode(completion: completion) { coordinate in
            guard let coordinate = coordinate else { return }
            self.setPinOnMap(coordinate: coordinate)

            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: span)
            self.mapView.region = region
        }
        backGroundView.isHidden = true
        completerScrollView.isHidden = true
        completerTableView.isHidden = true
    }
}

extension SearchBasePointViewController: MKMapViewDelegate {
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        view.endEditing(true)
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "PinAnnotationIdentifier"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        annotationView.annotation = annotation

        return annotationView
    }

    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            let controlButton = UIButton(type: .contactAdd)
            controlButton.tintColor = UIColor(hex: "FA6400")
            view.rightCalloutAccessoryView = controlButton
        }
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let registerBasePointView = UIStoryboard(name: "RegisterBasePointViewController", bundle: nil)
        guard let registerBasePointVC = registerBasePointView.instantiateInitialViewController() as? RegisterBasePointViewController else { return }
        registerBasePointVC.setCoordinate(coordinate: selectedCoordinate)
        navigationController?.show(registerBasePointVC, sender: nil)
    }
}

extension SearchBasePointViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if addressTextField.text != "" && !searchCompleter.results.isEmpty {
            setCompletion(completion: searchCompleter.results[0])
        } else {
            view.endEditing(true)
        }
        return true
    }
}

extension SearchBasePointViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SearchBasePointViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCompleterCell")
        cell.textLabel?.text = searchCompleter.results[indexPath.row].title
        cell.detailTextLabel?.text = searchCompleter.results[indexPath.row].subtitle
        return cell
    }
}

extension SearchBasePointViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        setCompletion(completion: searchCompleter.results[indexPath.row])
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

extension SearchBasePointViewController: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let address = addressTextField.text else { return }
        if !address.isEmpty {
            completerTableView.reloadData()
        }
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        var failedGetYourLocationAlert = UIAlertController()
        failedGetYourLocationAlert = UIAlertController(
            title: "場所の候補を取得することができませんでした",
            message: "インターネット接続を確認してください",
            preferredStyle: .alert
        )
        failedGetYourLocationAlert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        present(failedGetYourLocationAlert, animated: true)
    }
}
