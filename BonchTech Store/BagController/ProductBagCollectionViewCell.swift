//
//  ProductBagCollectionViewCell.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 26.04.2023.
//

import UIKit

class ProductBagCollectionViewCell: UICollectionViewCell {
    
    var product: BagProduct!
    var fullProduct: Product!
    
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var ProductCount: UILabel!
    @IBOutlet weak var OldPrice: UILabel!
    @IBOutlet weak var CurrentPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ProductImage.layer.cornerRadius = 10
        // Установка скругления углов
        contentView.layer.cornerRadius = 10
    }
    
    func cellDesign(product: BagProduct, cell: ProductBagCollectionViewCell){
        
        self.product = product
        
        ProductName.text = product.nameProduct
        ProductCount.text = String(product.count)
    }

    
    @IBAction func AddProductUnit(_ sender: Any) {
        CoreDataManager.shared.updataProduct(with: product.nameProduct!, newCount: (Int(product.count) + 1))
        
        guard let collectionView = self.superview as? UICollectionView else {
            return
        }
        
        ProductCount.text = "\(product.count)"
        collectionView.reloadData()
        
    }
    @IBAction func DeleteProductUnit(_ sender: UIButton) {
        
        if product.count == 1 {
            CoreDataManager.shared.deleteProduct(with: product.nameProduct!)
            print("товара был один")
            
// тоже работает но обновляет всю таблицу целиком
            guard let collectionView = self.superview as? UICollectionView else {
                return
            }
            collectionView.reloadData()
            
            
// удаляет ячейку
//            guard let collectionView = self.superview as? UICollectionView else {
//                return
//            }
//            let point = sender.convert(CGPoint.zero, to: collectionView)
//            guard let indexPath = collectionView.indexPathForItem(at: point),
//                  let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell else {
//                return
//            }
//            collectionView.deleteItems(at: [indexPath])
            
        } else {
            CoreDataManager.shared.updataProduct(with: product.nameProduct!, newCount: (Int(product.count) - 1))
            
            ProductCount.text = "\(product.count)"
            
            guard let collectionView = self.superview as? UICollectionView else {
                return
            }
            collectionView.reloadData()
        }
    }
}
