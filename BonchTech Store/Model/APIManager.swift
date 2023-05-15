//
//  APIManager.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 20.03.2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore


class APIManager {
    
    static let shared = APIManager()
    
    static func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getMultipleCollection(completion: @escaping ([ProductCategory]?) -> Void) {
        let db = APIManager.configureFB()
        
        var categories = [ProductCategory]()
        
        db.collection("Catalog").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    
                    let category = document.data()
                    
                    //print(category)
                    
                    categories.append(ProductCategory(title: category["title"] as! String, name: category["name"] as! String))
                }
            }
            completion(categories)
        }
    }
    
    func getMultipleFeedback(category: String, product: String, completion: @escaping ([Feedback]?) -> Void){
        let db = APIManager.configureFB()
        
        var feedbacks = [Feedback]()
        
        db.collection("Catalog").document(category).collection("products").document(product).collection("Comment").getDocuments() { (querySnapshot, err) in
            guard err == nil else {completion(nil); return}
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    //print("\(document.documentID) => \(document.data())")
                    
                    let feedback = document.data()
                    
                    feedbacks.append(Feedback(rating: feedback["rating"] as? Int ?? 0, comment: feedback["comment"] as? String ?? "hi", user: feedback["user"] as? String ?? "User"))
                }
            }
            completion(feedbacks)
        }
    }
    
    func getMultipleSpecification(category: String, product: String, completion: @escaping (Specifications?) -> Void) {
        let db = APIManager.configureFB()
        
        var specifications: Specifications!
        
        db.collection("Catalog").document(category).collection("products").document(product).collection("Specifications").getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()

                    if let characteristics = data["Характеристики"]{
                        let specs = Specifications(Specifications: characteristics as! [String : Any])
                        specifications = specs
                    }
                }
                completion(specifications)
            }
        }
    }
    
    func getMultipleProduct(category: String, product: String, completion: @escaping (Product?) -> Void){
        let db = APIManager.configureFB()
        
        var products: Product!
        
        db.collection("Catalog").document(category).collection("products").document(product).getDocument() { (querySnapshot, err) in
            guard err == nil else {completion(nil); return}
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let product = querySnapshot?.data()
                    
                products = ( Product(name: product?["name"] as? String ?? "nil", currentPrice: product?["currentPrice"] as? Int ?? 0, oldPrice: product?["oldPrice"] as? Int ?? 0, sale: product?["sale"] as? Bool ?? false, discountPercentage: product?["discountPercentage"] as? Int ?? 0, productImages: product?["productImages"] as? [String] ?? [] ))
            }
            completion(products)
        }
    }
    
    func getMultipleAll(document: String, completion: @escaping ([Product]?) -> Void){
        let db = APIManager.configureFB()
        
        var products = [Product]()
        
        db.collection("Catalog").document(document).collection("products").getDocuments() { (querySnapshot, err) in
            guard err == nil else {completion(nil); return}
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    //print("\(document.documentID) => \(document.data())")
                    
                    let product = document.data()
                    
                    products.append( Product(name: product["name"] as? String ?? "nil", currentPrice: product["currentPrice"] as? Int ?? 0, oldPrice: product["oldPrice"] as? Int ?? 0, sale: product["sale"] as? Bool ?? false, discountPercentage: product["discountPercentage"] as? Int ?? 0, productImages: product["productImages"] as? [String] ?? [] ))
                }
            }
            completion(products)
        }
    }
    
    
    func getMultiplePromotion(document: String, completion: @escaping ([Promotion]?) -> Void){
        let db = APIManager.configureFB()
        
        var promotions = [Promotion]()
        
        db.collection("promotions").getDocuments() { (querySnapshot, err) in
            guard err == nil else {completion(nil); return}
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    //print("\(document.documentID) => \(document.data())")
                    
                    let product = document.data()
                    
                    promotions.append(Promotion(name: product["name"] as? String ?? "", description: product["description"] as? String ?? ""))
                }
            }
            completion(promotions)
        }
    }
    
    // Отправка на сервер информации о заказе
    func addComment(category: String, product: String, rating: Int, comment: String, user: String) -> String {

            let db = APIManager.configureFB()
            
            var ref: DocumentReference? = nil
            
    // Добавление документа
        ref = db.collection("Catalog").document(category).collection("products").document(product).collection("Comment").addDocument(data: [
                "comment": comment,
                "rating": rating,
                "user": user,
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            return "\(ref!.documentID)"
    }
    
    func addDocument(name: String, phoneNumber: Int, city: String, address: String, idProducts: [String]) -> String {

        let db = APIManager.configureFB()
        
        var ref: DocumentReference? = nil
        
// Добавление документа
        ref = db.collection("order").document("user").collection("order").addDocument(data: [
            "name": name,
            "phone number": phoneNumber,
            "city": city,
            "address": address,
            "products": idProducts
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        return "\(ref!.documentID )"
    }
    
    func getImage(imageSection: String, imageName: String, completeon: @escaping(UIImage) -> Void) {
            let storage = Storage.storage()
            let reference = storage.reference()
            let pathRef = reference.child(imageSection)

            var image: UIImage = UIImage(named: "defaultImage")!
            
            let fileRef = pathRef.child(imageName + ".jpeg")
            
            fileRef.getData(maxSize: 2000*2000, completion: {data, error in
                guard error == nil else {completeon(image); return}
                image = UIImage(data: data!)!
                completeon(image)
                
            })
        }
}
