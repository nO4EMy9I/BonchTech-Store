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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    func cellDesign(cell: SpecificationsProfuctTableViewCell, key: String, value: String){
        
        cell.label.text = key
        cell.label2.text = value
        
        
        
    }
    
}
