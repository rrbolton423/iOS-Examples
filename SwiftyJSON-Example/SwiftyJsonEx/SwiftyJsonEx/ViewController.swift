//
//  ViewController.swift
//  SwiftyJsonEx
//
//  Created by Romell Bolton on 12/15/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {
    
    // Initialize empty Array of article titles
    var titles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make network request using API singleton
        NetworkingAPI.sharedInstance.getJSON { [weak self] (json, error) in
            
            // If the request was successful...
            if error == nil {
                
                // Obtain the array "results" from the json object
                // and getting it's array value using SwiftyJSON syntax,
                let results = json!["results"].arrayValue
                
                // Loop through the "result"s array
                for result in results {
                    
                    // Get the "title" object from the "results" array
                    // and getting it's string value using SwiftyJSON syntax
                    let title = result["title"].stringValue
                    
                    // Add each title to the titles array
                    self?.titles.append(title)
                }
                
                // Hop on the Main thread
                DispatchQueue.main.async {
                    
                    // Reload the TableView with fresh data
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // Return the number of sections in the TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of rows in the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    // Return the Cells for the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a UITableViewCell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        // Configure the cell's data
        cell.textLabel?.text = titles[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    
    
}

