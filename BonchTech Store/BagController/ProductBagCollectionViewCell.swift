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
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ProductImage.layer.cornerRadius = 10
        // Установка скругления углов
        contentView.layer.cornerRadius = 10
    }
    
    func cellDesign(bagProduct: BagProduct, product: Product, cell: ProductBagCollectionViewCell){
        
        self.product = bagProduct
        
        ProductName.text = bagProduct.nameProduct
        ProductCount.text = String(bagProduct.count)
        CurrentPrice.text = String(product.currentPrice) + "₽"
        if product.sale == true{
            self.OldPrice.attributedText = NSAttributedString(string: "\(String(product.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        } else {
            self.OldPrice.isHidden = true
        }
    }

    
    @IBAction func AddProductUnit(_ sender: Any) {
        CoreDataManager.shared.updataProduct(with: product.nameProduct!, newCount: (Int(product.count) + 1))
        
        guard let collectionView = self.superview as? UICollectionView else {
            return
        }
        
        ProductCount.text = "\(product.count)"
        delegate?.didUpdateProductQuantity()
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
            delegate?.didUpdateProductQuantity()
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
            delegate?.didUpdateProductQuantity()
            collectionView.reloadData()
        }
    }
}
