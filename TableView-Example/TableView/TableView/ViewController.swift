//
//  ViewController.swift
//  TableView
//
//  Created by Romell Bolton on 12/14/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

// Have VC containing TableView conform to protocols "UITableViewDelegate" & "UITableViewDataSource"
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Create data source array for TableView
    let list = ["Milk", "Honey", "Bread", "Tacos", "Tomatoes", "Apples", "Sugar", "Cookies", "Eggs", "Bacon", "Fruit Snacks", "Noodles", "Tofu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows we want in our list
        return list.count
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Populate TableView cells */
        
        // Create an instance of UITableViewCell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        // Populate the cell with data from the 'list' array, using the indexPath
        // in subscript notation. Move down all array items
        cell.textLabel?.text = list[indexPath.row]
        
        // Return the populated cell
        return cell
    }

}

