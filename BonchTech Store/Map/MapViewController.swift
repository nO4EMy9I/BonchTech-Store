//
//  MapViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 22.05.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var initialLocationSet = false
    let locationManager = CLLocationManager ()
    var shop: Shop!
    
    @IBOutlet weak var SityButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopUpButton()
        
        APIManager.shared.getMultipleShops(){ shops in
            
            for i in shops!{
                self.shop = Shop(street: i.street, coordinate: i.coordinate)
                self.mapView.addAnnotation(self.shop)
            }
        }
        
        // Экземпляр класса MKMapView.CameraZoomRange
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1000, maxCenterCoordinateDistance: 15000)

        // Установка иапазона масштабов для камеры карты
        mapView.setCameraZoomRange(zoomRange, animated: false)

        let tileOverlay = MKTileOverlay(urlTemplate: "URL_TEMPLATE_TO_LOW_DETAIL_TILES")
        tileOverlay.canReplaceMapContent = true
        mapView.addOverlay(tileOverlay, level: .aboveLabels)


        //mapView.addAnnotation(shop)
        mapView.userTrackingMode = .none
    }
    
    
    //Тест
    func setupPopUpButton() {
        // Данные о городах
        let cities = ["Москва", "Санкт-Петербург", "Нью-Йорк", "Лондон", "Париж"]
        
        var menuItems: [UIAction] = []
        
        // Элементы меню на основе городов
        for city in cities {
            let action = UIAction(title: city, handler: { _ in
                print(city)
                //Дополнительные действия при выборе города
            })
            
            menuItems.append(action)
        }
        
        // Меню на основе элементов
        SityButton.menu = UIMenu(children: menuItems)
        
        SityButton.showsMenuAsPrimaryAction = true
        SityButton.changesSelectionAsPrimaryAction = true
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
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last?.coordinate{
//            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
//            mapView.setRegion(region, animated: false)
//        }
        
        guard let location = locations.last?.coordinate else {
            return
        }
        
        if !initialLocationSet {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: false)
            initialLocationSet = true
        }
        
        locationManager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
