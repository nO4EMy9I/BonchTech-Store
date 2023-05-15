//
//  ProductViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 03.04.2023.
//

import UIKit

class ProductViewController: UIViewController {
    
    var selectedProduct: Product!
    var product: Product!
    var way:[String] = []
    var feedback = [Feedback]()

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var ProductRatingsLabel: UILabel!
    @IBOutlet weak var NameProduct: UILabel!
    @IBOutlet weak var CurrentPrice: UILabel!
    @IBOutlet weak var OldPrice: UILabel!
    @IBOutlet weak var CountCommentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getMultipleProduct(category: way[0], product: self.selectedProduct.name) { product in
            
            self.product = product!
            
            self.NameProduct.text = self.product.name
            self.CurrentPrice.text = "\(self.product.currentPrice)" + "₽"
            
            if product?.sale == true{
                self.OldPrice.attributedText = NSAttributedString(string: "\(String(product!.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            } else {
                self.OldPrice.isHidden = true
            }
            self.CollectionView.reloadData()
        }
        
        way.append(selectedProduct.name)

        self.CollectionView.dataSource = self
        self.CollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        CollectionView.collectionViewLayout = layout
        
//        NameProduct.text = product?.name
//        CurrentPrice.text = "\(product?.currentPrice)" + "₽"
        
//        if product.sale == false{
//            OldPrice.isHidden = true
//            let constraint = NSLayoutConstraint(item: CurrentPrice!, attribute: .top, relatedBy: .equal, toItem: NameProduct, attribute: .bottom, multiplier: 1, constant: 8)
//            NSLayoutConstraint.activate([constraint])
//        } else {
//            self.OldPrice.attributedText = NSAttributedString(string: "\(String(product.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
//        }
        //OldPrice.text = String(selectedProduct.oldPrice)
        
        APIManager.shared.getMultipleFeedback(category: way[0], product: way[1]) { feedback in
            guard feedback != nil else {return}
            
            self.feedback = feedback!
            self.CountCommentLabel.text = "Отзывы: \(feedback!.count)"
            
            self.ProductRatingsLabel.text = "Оценка: " + String(format: "%.1f", Double(feedback!.reduce(0) { $0 + $1.rating }) / Double(feedback!.count))
        }
    }
}

extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return product?.productImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! ProductPhotoCollectionViewCell
        
        APIManager.shared.getImage(imageSection: "productImages", imageName: String(describing: product.productImages[indexPath.row]), completeon: { image in
            
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
            destinationVC.feedback = self.feedback
        }
        
    }
}
