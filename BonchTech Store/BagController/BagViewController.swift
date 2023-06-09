//
//  BagViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 26.04.2023.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func didUpdateProductQuantity()
}


class BagViewController: UIViewController {

    @IBOutlet weak var bagCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    var userAction: Product!
    var products = [Product]()
    var bagProducts = [BagProduct]()
    var position: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.CollectionView.register(UINib(nibName: "ProductBagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bagCell")
        self.bagCollectionView.dataSource = self
        self.bagCollectionView.delegate = self
        self.bagCollectionView.layer.cornerRadius = 10
        self.bagCollectionView.showsVerticalScrollIndicator = false
        self.placeOrderButton.backgroundColor = .systemOrange
        self.placeOrderButton.tintColor = .white
        self.placeOrderButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bagProducts = CoreDataManager.shared.fetchProducts()
        
        var totalPrice = 0
        
        for product in bagProducts {
            totalPrice += Int(product.price) * Int(product.count)
        }

        priceLabel.text = "Цена товаров: " + String(totalPrice) + "₽"
        
        self.bagCollectionView.reloadData()
    }
    
    @IBAction func Test(_ sender: Any) {
        CoreDataManager.shared.deleteAllProduct()
    }

    
}

extension BagViewController: UICollectionViewDataSource, UICollectionViewDelegate, ProductCellDelegate{
    
    func didUpdateProductQuantity() {
        updateTotalPrice()
    }
    
    // Обновление суммы товаров в корзине
    func updateTotalPrice() {
        var totalPrice = 0
        //bagProducts = CoreDataManager.shared.fetchProducts()
        
        
        for product in bagProducts {
            totalPrice += Int(product.price) * Int(product.count)
        }
        
        print(totalPrice)
        
        priceLabel.text = "Цена товаров: \(totalPrice)₽"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        bagProducts = CoreDataManager.shared.fetchProducts()
        products.removeAll()
        
        return bagProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as! ProductBagCollectionViewCell
        cell.delegate = self
        let product = CoreDataManager.shared.fetchProducts()
//        print(product)
//        self.bagProducts.append(product[indexPath.row])
        
        
        if product[indexPath.row].category != nil {
            APIManager.shared.getMultipleProduct(category: product[indexPath.row].category ?? "", product: self.bagProducts[indexPath.row].nameProduct ?? "" ) { product in
                
                self.products.insert(product!, at: 0)
                cell.cellDesign(bagProduct: self.bagProducts[indexPath.row], product: self.products.first!, cell: cell)
            }
        }
        
        //cell.cellDesign(bagProduct: bagProducts[indexPath.row], product: products.first, cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        bagCollectionView.reloadData()
        
        let userAction = products[indexPath.item]
        
        self.position = indexPath.row
        self.userAction = userAction
        
        performSegue(withIdentifier: "toProductViewController", sender: userAction)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        CGSize(width: collectionView.frame.width, height: 128)
    }

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       if segue.identifier == "toProductViewController"{
           let destinationVC = segue.destination as! ProductViewController
           guard bagCollectionView.indexPathsForSelectedItems != nil else { return }
           
           destinationVC.selectedProduct = userAction
           destinationVC.way.append(bagProducts[position].category ?? "")
       }
        
        if segue.identifier == "toOrderViewController"{
            let destinationVC = segue.destination as! OrderViewController
            destinationVC.boughtProductsList = self.products
        }
    }
    
}
