//
//  ProductViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 03.04.2023.
//

import UIKit

class ProductViewController: UIViewController {
    
    var selectedProduct: Product!
    var way:[String] = []
    
    var testProduct: Product!

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var ProductRatingsLabel: UILabel!
    @IBOutlet weak var NameProduct: UILabel!
    @IBOutlet weak var CurrentPrice: UILabel!
    @IBOutlet weak var OldPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        way.append(selectedProduct.name)

        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        
        APIManager.shared.getMultipleProduct(category: way.first ?? "", product: selectedProduct.name) { product in
            self.testProduct = product!
            
            self.NameProduct.text = self.testProduct.name
            self.CurrentPrice.text = String(self.testProduct.currentPrice) + "₽"
            
            if self.testProduct.sale == false{
                self.OldPrice.isHidden = true
                let constraint = NSLayoutConstraint(item: self.CurrentPrice!, attribute: .top, relatedBy: .equal, toItem: self.NameProduct, attribute: .bottom, multiplier: 1, constant: 8)
                NSLayoutConstraint.activate([constraint])
            } else {
                self.OldPrice.attributedText = NSAttributedString(string: "\(String(self.testProduct.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            }
            //OldPrice.text = String(selectedProduct.oldPrice)
            
            let rating = (Double.random(in: 1.0...5.0) * 10).rounded(.toNearestOrAwayFromZero) / 10
            
            self.ProductRatingsLabel.text = "Оценка: \(rating) из 5"
            
            self.CollectionView.reloadData()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        CollectionView.collectionViewLayout = layout
        
//        NameProduct.text = testProduct.name
//        CurrentPrice.text = String(testProduct.currentPrice) + "₽"
//
//        if testProduct.sale == false{
//            OldPrice.isHidden = true
//            let constraint = NSLayoutConstraint(item: CurrentPrice!, attribute: .top, relatedBy: .equal, toItem: NameProduct, attribute: .bottom, multiplier: 1, constant: 8)
//            NSLayoutConstraint.activate([constraint])
//        } else {
//            self.OldPrice.attributedText = NSAttributedString(string: "\(String(testProduct.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
//        }
//        //OldPrice.text = String(selectedProduct.oldPrice)
//
//        let rating = (Double.random(in: 1.0...5.0) * 10).rounded(.toNearestOrAwayFromZero) / 10
//
//        ProductRatingsLabel.text = "Оценка: \(rating) из 5"
    }
    



}

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if testProduct == nil {
            return 0
        } else {
            return testProduct.productImages.count
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! ProductPhotoCollectionViewCell
        
        APIManager.shared.getImage(imageSection: "productImages", imageName: String(describing: testProduct.productImages[indexPath.row]), completeon: { image in
            
            cell.ProductPhotoImage.image = image
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        CGSize(width: 250, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 143
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 143
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 72)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "toSpecificationsProductTableViewController"{
           let destinationVC = segue.destination as! SpecificationsProductTableViewController
           destinationVC.way += way
        }
        
        if segue.identifier == "toCommentViewController"{
           let destinationVC = segue.destination as! CommentViewController
           destinationVC.way += way
        }
        
        if segue.identifier == "toCommentsTableViewController"{
           let destinationVC = segue.destination as! CommentsTableViewController
           destinationVC.way += way
        }
    }
}
