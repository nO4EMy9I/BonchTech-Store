//
//  PromotionsCollectionViewCell.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 20.03.2023.
//

import UIKit

class PromotionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PromotionsImage: UIImageView!
    
    func cellDesign(cell: PromotionsCollectionViewCell, promotion: Promotion){
        
        PromotionsImage.layer.cornerRadius = 15
        
    }
    
    
}
