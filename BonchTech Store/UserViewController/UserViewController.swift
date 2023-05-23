//
//  AuthorizationViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 20.05.2023.
//

import UIKit
import FirebaseAuth
import MapKit
import CoreLocation

class UserViewController: UIViewController {
    
    var visibilityLogOutButton = true
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let locationManager = CLLocationManager ()
    let shop = Shop(street: "Firest", coordinate: CLLocationCoordinate2D(latitude: 59.92799, longitude: 30.360782))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.0, *) {
            logOutButton.isHidden = visibilityLogOutButton
        } else {
            logOutButton.isEnabled = visibilityLogOutButton
        }
        
        mapView.addAnnotation(shop)
        mapView.layer.cornerRadius = 15
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false

        //Распознование жеста пользователя
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APIManager.shared.getMultipleUser(userId: Auth.auth().currentUser!.uid, completion: { user in
            self.pointsLabel.text = "Баллы: " + String(user?.points ?? 0)
            self.userNameLabel.text = user?.name
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    func setupManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled(){
            setupManager()
            checkAuthorization()
        } else {
            
            showAlertLocation(title: "Геолокация выключена", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    func checkAuthorization(){
        switch CLLocationManager().authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // Разрешение получено всегда
            break
        case .denied:
            showAlertLocation(title: "Вы запретили использование местоположения", message: "Хотите это изменить", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            // Разрешение ограничено
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        }
    }
    
    func showAlertLocation(title: String, message: String?, url: URL?){
        //"App-Prefs:root=LOCATION_SERVICES"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url{
                UIApplication.shared.open(url)
            }
        }
        
        let cancleAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func showBarButton(_ sender: Any) {
        
        visibilityLogOutButton = !visibilityLogOutButton
        
        if #available(iOS 16.0, *) {
            logOutButton.isHidden = visibilityLogOutButton
        } else {
            logOutButton.isEnabled = visibilityLogOutButton
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    @IBAction func test(_ sender: Any) {
        
        let latitude = 59.92799
        let longitude = 30.360782
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // Создаем регион с сгенерированными координатами
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        // Перемещаем карту к сгенерированным координатам
        mapView.setRegion(region, animated: true)

    }
    
    
    //Переход к другому VC
    @objc func mapViewTapped() {
        performSegue(withIdentifier: "toMapViewController", sender: self)
    }
}

extension UserViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 2500, longitudinalMeters: 2500)
            mapView.setRegion(region, animated: true)
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
