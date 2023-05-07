//
//  CodeDataManager.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 27.04.2023.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject{
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
//    public func test(){
//        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
//            print ("DB url - \(url)")
//        }
//    }
    
    public func createProduct(name nameProduct: String, category: String, price: Int16 ) {
        guard let productEntityDescription = NSEntityDescription.entity(forEntityName: "BagProduct", in: context) else { return }
        let product = BagProduct(entity: productEntityDescription, insertInto: context)
        product.nameProduct = nameProduct
        product.count = 1
        product.category = category
        product.price = price
        
        appDelegate.saveContext()
    }
    
    public func fetchProducts() -> [BagProduct] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BagProduct")
        do{
            return try context.fetch(fetchRequest) as! [BagProduct]
            //return (try? context.fetch(fetchReqest) as? [BagProduct]) ?? []
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func fetchProduct(_ nameProduct: String) -> BagProduct? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BagProduct")
        do{
            guard let products = try? context.fetch(fetchRequest) as? [BagProduct] else { return nil }
            return products.first(where: { $0.nameProduct == nameProduct })
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func updataProduct(with nameProduct: String, newCount: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BagProduct")
        do{
            guard let products = try? context.fetch(fetchRequest) as? [BagProduct],
                  let product = products.first(where: { $0.nameProduct == nameProduct }) else { return }
            product.count = Int16(newCount)
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllProduct(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BagProduct")
        do {
            let products = try? context.fetch(fetchRequest) as? [BagProduct]
            products?.forEach {context.delete($0) }
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteProduct(with productName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BagProduct")
        do {
            guard let products = try? context.fetch(fetchRequest) as? [BagProduct],
                  let product = products.first(where: { $0.nameProduct == productName }) else { return }
            
            context.delete(product)
        }
        
        appDelegate.saveContext()
    }
}
