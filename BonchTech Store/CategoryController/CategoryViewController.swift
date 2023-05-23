//
//  CatalogViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 01.04.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryViewController: UICollectionViewController{

    var userAction: ProductCategory!
    var categories = [ProductCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.shared.getMultipleCollection { categories in
            guard categories != nil else {return}
            self.categories = categories!
            
            //print(self.categories)
            
            self.collectionView.reloadData()
        }

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! ProductCategoryViewCell
    
        cell.categoryLabel.text = categories[indexPath.item].title
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userAction = categories[indexPath.item]
        
        self.userAction = userAction
        
        performSegue(withIdentifier: "toCatalogViewController", sender: userAction)
    }


}

extension CategoryViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 0, height: 64)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
       if segue.identifier == "toCatalogViewController"{
           let destinationVC = segue.destination as! CatalogCollectionViewController
           guard collectionView.indexPathsForSelectedItems != nil else { return }
           destinationVC.selectedCategory = userAction
       }
    }
}
