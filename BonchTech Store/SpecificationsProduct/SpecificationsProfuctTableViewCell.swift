//
//  SpecificationsProfuctTableViewCell.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 03.04.2023.
//

import UIKit

class SpecificationsProfuctTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBOutlet weak var characteristicLabel: UILabel!
    @IBOutlet weak var valueOfCharacteristicLabel: UILabel!
    
    func cellDesign(cell: SpecificationsProfuctTableViewCell, key: String, value: String){
        
        characteristicLabel.text = key
        valueOfCharacteristicLabel.text = value
    }
    
}
