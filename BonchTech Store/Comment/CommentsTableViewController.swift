//
//  CommentsTableViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 25.04.2023.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var feedback = [Feedback]()
    var way: [String] = []
    var averageRating: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
//        APIManager.shared.getMultipleFeedback(category: way[0], product: way[1]) { feedback in
//            guard feedback != nil else {return}
//
//            self.feedback = feedback!
//
//            self.tableView.reloadData()
//
//            self.averageRating = Double(feedback!.reduce(0) { $0 + $1.rating }) / Double(feedback!.count)
//                //print(self.averageRating)
//        }
        
    }



    override func numberOfSections(in tableView: UITableView) -> Int {

        return feedback.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.feedback[section].user
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell

        cell.cellDesign(feedback: feedback[indexPath.section], cell: cell)
        
        //cell.RatingLabel.text = "Оценка: \(feedback[indexPath.section].rating) из 5"
        //cell.CommentLabel.text = "Комментарий: \(feedback[indexPath.section].comment)"

        return cell
    }
}
