//
//  PromotionViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 13.05.2023.
//

import UIKit

class PromotionViewController: UIViewController {

    
    @IBOutlet weak var promotionImage: UIImageView!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionDescriptionLabel: UILabel!
    
    var promotion: Promotion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.promotionNameLabel.text = promotion.name
        self.promotionDescriptionLabel.text = promotion.description
        
        APIManager.shared.getImage(imageSection: "pic", imageName: String(describing: self.promotion.name), completeon: { image in

            self.promotionImage.image = image
        })
    }
    



}
