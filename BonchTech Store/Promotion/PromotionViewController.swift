//
//  PromotionViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 13.05.2023.
//

import UIKit

class PromotionViewController: UIViewController {

    
    @IBOutlet weak var PromotionImage: UIImageView!
    @IBOutlet weak var PromotionName: UILabel!
    @IBOutlet weak var PromotionDescription: UILabel!
    
    var promotion: Promotion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PromotionName.text = promotion.name
        self.PromotionDescription.text = promotion.description
        
        APIManager.shared.getImage(imageSection: "pic", imageName: String(describing: self.promotion.name), completeon: { image in

            self.PromotionImage.image = image
        })
    }
    



}
