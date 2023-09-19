//
//  MapViewController.swift
//  RideSharer
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLocation()
    }

    private func checkUserLocation() {
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                showUserLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                showUserLocation()
            case .restricted:
                handleRestrictedLocation()
            case .denied:
                handleDisabledLocation()
            @unknown default:
                break
        }
    }

    private func showUserLocation() {
        mapView.showsUserLocation = true
        locationManager.location.map {
            mapView.setCenter($0.coordinate, animated: true)
        }
    }

    private func handleRestrictedLocation() {
        let alertController = UIAlertController(title: "Location access restricted", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func handleDisabledLocation() {
        let alertController = UIAlertController(title: "Location access disabled", message: "Please allow location access", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}
