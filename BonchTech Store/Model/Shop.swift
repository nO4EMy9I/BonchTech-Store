//
//  Shop.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 22.05.2023.
//

import Foundation
import MapKit

class Shop: NSObject, MKAnnotation{
    
    var street: String
    var coordinate: CLLocationCoordinate2D
    
    init(street: String, coordinate: CLLocationCoordinate2D) {
        self.street = street
        self.coordinate = coordinate
    }
}
