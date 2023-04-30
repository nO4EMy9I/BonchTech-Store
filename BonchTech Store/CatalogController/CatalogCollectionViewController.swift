//
//  CatalogCollectionViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 01.04.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class CatalogCollectionViewController: UICollectionViewController {

    
    var userAction: Product!
    var products = [Product]()
    var selectedCategory: ProductCategory!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory.title

        APIManager.shared.getMultipleAll(document: selectedCategory!.name) { products in
            guard products != nil else {return}
            self.products = products!
            
            self.collectionView.reloadData()
        }
        
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumLineSpacing = 4
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        flowLayout.minimumInteritemSpacing = 4

        collectionView.collectionViewLayout = flowLayout
        

        self.collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "productCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        cell.cellDesign(product: products[indexPath.item], category: selectedCategory.name, cell: cell)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userAction = products[indexPath.item]
        
        self.userAction = userAction
        
        performSegue(withIdentifier: "toProductViewController", sender: userAction)
    }


}

extension CatalogCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        CGSize(width: (collectionView.frame.width - 24) / 2, height: 305)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
       if segue.identifier == "toProductViewController"{
           let destinationVC = segue.destination as! ProductViewController
           guard collectionView.indexPathsForSelectedItems != nil else { return }
           destinationVC.selectedProduct = userAction
           destinationVC.way.append(selectedCategory.name)
       }
    }
}
