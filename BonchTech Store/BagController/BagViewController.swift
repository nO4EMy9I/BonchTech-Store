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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.CollectionView.register(UINib(nibName: "ProductBagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bagCell")
        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        self.CollectionView.layer.cornerRadius = 10
        self.CollectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CollectionView.reloadData()
    }
    
    @IBAction func Test(_ sender: Any) {
        CoreDataManager.shared.deleteAllProduct()
    }
    
}

extension BagViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return CoreDataManager.shared.fetchProducts().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath) as! ProductBagCollectionViewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        CollectionView.reloadData()
        
        let userAction = products[indexPath.item]
    
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
           destinationVC.selectedProduct = userAction
           destinationVC.way.append(bagProducts[0].category ?? "")
       }
    }
    
}