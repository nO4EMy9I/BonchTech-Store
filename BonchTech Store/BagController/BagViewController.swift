//
//  BagViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 26.04.2023.
//

import UIKit

class BagViewController: UIViewController {

    @IBOutlet weak var CollectionView: UICollectionView!
    var userAction: Product!
    var products = [Product]()
    var bagProducts = [BagProduct]()
    var qq: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.CollectionView.register(UINib(nibName: "ProductBagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bagCell")
        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        self.CollectionView.layer.cornerRadius = 10
        self.CollectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        bagProducts = CoreDataManager.shared.fetchProducts()
        self.CollectionView.reloadData()
    }
    
    @IBAction func Test(_ sender: Any) {
        CoreDataManager.shared.deleteAllProduct()
    }
    
}

extension BagViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Начало тут")

        bagProducts = CoreDataManager.shared.fetchProducts()
        products.removeAll()
        
        return bagProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as! ProductBagCollectionViewCell
        
        let product = CoreDataManager.shared.fetchProducts()
//        print(product)
//        self.bagProducts.append(product[indexPath.row])
        
        
        if let gg = product[indexPath.row].category {
            APIManager.shared.getMultipleProduct(category: product[indexPath.row].category ?? "", product: self.bagProducts[indexPath.row].nameProduct ?? "" ) { product in
                
                self.products.insert(product!, at: 0)
            }
        }
        
        cell.cellDesign(product: bagProducts[indexPath.row], cell: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        CollectionView.reloadData()
        
        let userAction = products[indexPath.item]
        
        self.qq = indexPath.row
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
           guard CollectionView.indexPathsForSelectedItems != nil else { return }
           
           for i in products{
               print(i.name)
           }
           
           print("___")
           
           destinationVC.selectedProduct = userAction
           //destinationVC.way.append()
           destinationVC.way.append(bagProducts[qq].category ?? "")
       }
    }
    
}
