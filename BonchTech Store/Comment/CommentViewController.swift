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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(way)
        
        CommentTextView.placeholder = "Оставьте отзыв"
        CommentTextView.layer.borderWidth = 1
        CommentTextView.layer.borderColor = UIColor.systemOrange.cgColor
        CommentTextView.layer.cornerRadius = 10
    }
    
    @IBAction func addComment(_ sender: Any) {
        APIManager.shared.addComment(category: way[0], product: way[1], rating: Int(Rating.titleForSegment(at: Rating.selectedSegmentIndex) ?? "0")!, comment: CommentTextView.text, user: "user")
        dismiss(animated: true, completion: nil)
     }
}

