//
//  SpecificationsProductTableViewController.swift
//  BonchTech Store
//
//  Created by Nikita Voronov on 03.04.2023.
//

import UIKit

class SpecificationsProductTableViewController: UITableViewController {
    
//    var specifications: Specifications!
    var section: [String] = []
    var settings: [[String:String]] = []
    var way: [String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APIManager.shared.getMultipleSpecification(category: way[0], product: way[1] ) { specifications in
            guard specifications != nil else {return}
            
            self.section.append(contentsOf: specifications!.Specifications.keys)
            
            for (_, value) in specifications!.Specifications{
                self.settings.append(value as! [String : String])
            }
            
            self.tableView.reloadData()
        }

        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension SpecificationsProductTableViewController {
    
        
    override func numberOfSections(in tableView: UITableView) -> Int {

        return self.section.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.settings[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "specificationsCell", for: indexPath) as! SpecificationsProfuctTableViewCell
        
        cell.cellDesign(cell: cell, key: Array(self.settings[indexPath.section].keys)[indexPath.row] , value: Array(self.settings[indexPath.section].values)[indexPath.row])
        
        return cell
    }
}
