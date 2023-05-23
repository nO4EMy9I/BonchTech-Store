//
//  СommentViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 21.04.2023.
//

import UIKit

class CommentViewController: UIViewController {
    
    var way: [String] = []

    @IBOutlet weak var CommentTextView: UITextView!
    @IBOutlet weak var Rating: UISegmentedControl!
    @IBOutlet weak var commentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(way)
        commentButton.layer.cornerRadius = 15
        
        CommentTextView.placeholder = "Спасибо за отзыв!"
        CommentTextView.layer.borderWidth = 1
        CommentTextView.layer.borderColor = UIColor.systemOrange.cgColor
        CommentTextView.layer.cornerRadius = 10
    }
    
    @IBAction func addComment(_ sender: Any) {
        APIManager.shared.addComment(category: way[0], product: way[1], rating: Int(Rating.titleForSegment(at: Rating.selectedSegmentIndex) ?? "0")!, comment: CommentTextView.text, user: "user")
        dismiss(animated: true, completion: nil)
     }
}

