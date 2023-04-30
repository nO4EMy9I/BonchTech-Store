//
//  BagProduct+CoreDataProperties.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 27.04.2023.
//
//

import Foundation
import CoreData

@objc(BagProduct)
public class BagProduct: NSManagedObject {

}

extension BagProduct {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<BagProduct> {
//        return NSFetchRequest<BagProduct>(entityName: "BagProduct")
//    }

    @NSManaged public var nameProduct: String?
    @NSManaged public var count: Int16
    @NSManaged public var category: String?
}

extension BagProduct : Identifiable {

}
