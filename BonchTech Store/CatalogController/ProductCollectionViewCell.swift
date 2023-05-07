//
//  ProductCollectionViewCell.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 01.04.2023.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var like: UIButton!
    
    var product: Product!
    var category: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func cellDesign(product: Product, category: String, cell: ProductCollectionViewCell){
        
        self.category = category
        
        self.product = product
        APIManager.shared.getImage(imageSection: "productImages", imageName: String(describing: product.productImages.first ?? ""), completeon: { image in
            
            self.image.image = image
        })
        
        self.name.text = product.name
        self.name.numberOfLines = 2
        //self.name.lineBreakMode = .byWordWrapping
        self.name.lineBreakMode = .byTruncatingTail
        
        self.currentPrice.text = String("\(product.currentPrice)₽")
        if product.sale == false{
            oldPrice.isHidden = true
        } else {
            self.oldPrice.attributedText = NSAttributedString(string: "\(String(product.oldPrice))₽", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        }
        self.image.layer.cornerRadius = 15
        
        self.addButton.backgroundColor = UIColor.systemOrange
        self.addButton.layer.cornerRadius = 15
        self.addButton.setTitle("В корзину", for: .normal)
        self.addButton.setTitleColor(.white, for: .normal)
        
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.systemOrange.cgColor

        let image = UIImage(systemName: "heart.fill")
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "", attributes: attributes)
        if let image = image {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedTitle.append(imageString)
        }
        like.setAttributedTitle(attributedTitle, for: .normal)
        
        
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.3
//        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
//        cell.layer.shadowRadius = 4
//        cell.layer.masksToBounds = false
//        cell.clipsToBounds = true
//        cell.layer.shouldRasterize = true
//        cell.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addToCart(_ product: Product) {
        if CoreDataManager.shared.fetchProduct(product.name) == nil {
            CoreDataManager.shared.createProduct(name: product.name, category: category, price: Int16(product.currentPrice))
            print("товара не было")
        } else {
            let count = CoreDataManager.shared.fetchProduct(product.name)!.count
            CoreDataManager.shared.updataProduct(with: product.name, newCount: (Int(count) + 1))
            print("товар был")
        }
    }

    @IBAction func add(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        // Ждем 0.1 секунды и возвращаем кнопку в изначальный размер
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.transform = CGAffineTransform.identity
        }
        
        addToCart(product)
    }
    
}
