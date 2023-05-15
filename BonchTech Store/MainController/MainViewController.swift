//
//  MainViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 14.03.2023.
//

import UIKit


class MainViewController: UIViewController {

    var promotions = [Promotion]()
    var userAction: Promotion!
    
    @IBOutlet weak var PromotionsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PromotionsCollection.dataSource = self
        PromotionsCollection.delegate = self
        PromotionsCollection.showsHorizontalScrollIndicator = false

        APIManager.shared.getMultiplePromotion(document: "sale", completion: {products in
            guard products != nil else {return}
            self.promotions = products!

            self.PromotionsCollection.reloadData()
        })
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)


        PromotionsCollection.collectionViewLayout = flowLayout
        PromotionsCollection.delegate = self
        PromotionsCollection.dataSource = self
    }
    
//    override func viewWillLayoutSubviews() {
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return promotions.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "promoCell", for: indexPath) as! PromotionsCollectionViewCell
        
        APIManager.shared.getImage(imageSection: "pic", imageName: String(describing: self.promotions[indexPath.row].name ?? ""), completeon: { image in

            cell.PromotionsImage.image = image
        })
        
        let promotion = promotions[indexPath.item]
        
        cell.cellDesign(cell: cell, promotion: promotion)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userAction = promotions[indexPath.item]
        
        self.userAction = userAction
        
        performSegue(withIdentifier: "toPromotionViewController", sender: userAction)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 227, height: 128)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       if segue.identifier == "toPromotionViewController"{
           let destinationVC = segue.destination as! PromotionViewController
           guard PromotionsCollection.indexPathsForSelectedItems != nil else { return }
           destinationVC.promotion = userAction
       }
    }

}
