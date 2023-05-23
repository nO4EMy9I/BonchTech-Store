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
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImage.layer.cornerRadius = 10
        // Установка скругления углов
        contentView.layer.cornerRadius = 10
    }
    
    func cellDesign(bagProduct: BagProduct, product: Product, cell: ProductBagCollectionViewCell){
        self.product = bagProduct
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        cell.layer.cornerRadius = 15
        
        productNameLabel.text = bagProduct.nameProduct
        productCountLabel.text = String(bagProduct.count)
        currentPriceLabel.text = String(product.currentPrice) + "₽"
        if product.sale == true{
            self.oldPriceLabel.attributedText = NSAttributedString(string: "\(String(product.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        } else {
            self.oldPriceLabel.isHidden = true
        }
        APIManager.shared.getImage(imageSection: "productImages", imageName: String(describing: product.productImages.first ?? ""), completeon: { image in
            
            self.productImage.image = image
        })
    }
    
    //Увеличение единиц товара в корзине
    @IBAction func AddProductUnit(_ sender: Any) {
        CoreDataManager.shared.updataProduct(with: product.nameProduct!, newCount: (Int(product.count) + 1))
        guard let collectionView = self.superview as? UICollectionView else {
            return
        }
        
        productCountLabel.text = "\(product.count)"
        delegate?.didUpdateProductQuantity()
        collectionView.reloadData()
        
    }
    
    //Уменьшение удиниц товара в корзине
    @IBAction func DeleteProductUnit(_ sender: UIButton) {
        
        if product.count == 1 {
            CoreDataManager.shared.deleteProduct(with: product.nameProduct!)
            print("товара был один")
            
            guard let collectionView = self.superview as? UICollectionView else {
                return
            }
            delegate?.didUpdateProductQuantity()
            collectionView.reloadData()
        } else {
            CoreDataManager.shared.updataProduct(with: product.nameProduct!, newCount: (Int(product.count) - 1))
            
            productCountLabel.text = "\(product.count)"
            
            guard let collectionView = self.superview as? UICollectionView else {
                return
            }
            delegate?.didUpdateProductQuantity()
            collectionView.reloadData()
        }
    }
}
