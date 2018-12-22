//
//  ViewController.swift
//  JSONSerialization
//
//  Created by Romell Bolton on 12/21/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // Instantiate an empty array of Strings for the TableView
    var tableArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the dataSource and delegate to the current View Controller
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Make API call and parse the JSON
        parseJSON()
    }
    
    // This method parses JSON using the JSONSerialization class, converting it into a Foundation object
    func parseJSON() {
        
        // Create URL to API
        let url = URL(string: "https://api.myjson.com/bins/vi56v")
        
        // Create data task, passing the url which returns data, response, and error in a closure
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            // If there is an error, return from the method
            guard error == nil else {
                print("returned error")
                return
            }
            
            // If the data returned is nil, return from the method
            guard let content = data else {
                print("no data")
                return
            }
            
            // JSONSerialization: An object that converts between JSON and the equivalent Foundation objects.
            // .jsonObject(): Returns a Foundation object from given JSON data.
            // Convert the downloaded content / data into a JSON object using JSONSerialization, then casting that
            // object to a Foundation object, "String to Any" Dictionary
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String:Any] else {
                
                // If the conversion is failed, pring error and return from the method
                print("not containing JSON")
                return
            }
            
            // Access the array under the key "companies" in the json dictionary
            // Cast the array as a String array
            if let array = json["companies"] as? [String] {
                
                // Persist the array to the ViewController's tableArray property
                self.tableArray = array
            }
            
            // Print the array
            print(self.tableArray)
            
            // Go to the main thread
            DispatchQueue.main.async {
                
                // Reload the table view using the newest array downloaded and parsed from the API
                self.tableView.reloadData()
            }
        }
        
        // Resume / start the task
        task.resume()
    }
    
}

// Handle TableView methods in extension
extension ViewController {
    
    // Configure and return the cells in the Table View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Instantiate a UITableViewCell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        // Configure each cell's text using the table array
        cell.textLabel?.text = self.tableArray[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    // Return the number of items in the Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the count of the table array
        return self.tableArray.count
    }
}

