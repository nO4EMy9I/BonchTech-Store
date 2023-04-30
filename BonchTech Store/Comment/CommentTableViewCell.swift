//
//  CommentTableViewCell.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 25.04.2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var CommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellDesign(feedback: Feedback, cell: CommentTableViewCell){
        
        RatingLabel.text = "Оценка: \(feedback.rating) из 5"
        CommentLabel.text = "Комментарий: \(feedback.comment)"
        
        
    }
        

}
