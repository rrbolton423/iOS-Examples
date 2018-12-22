//
//  ViewController.swift
//  JSONSerialization
//
//  Created by Romell Bolton on 12/21/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var tableArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        parseJSON()
    }
    
    func parseJSON() {
        
        let url = URL(string: "https://api.myjson.com/bins/vi56v")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("no data")
                return
            }
            
            // JSONSerialization: An object that converts between JSON and the equivalent Foundation objects.
            // .jsonObject(): Returns a Foundation object from given JSON data.
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: .mutableContainers)) as? [String:Any] else {
                print("not containing JSON")
                return
            }
            
            if let array = json["companies"] as? [String] {
                self.tableArray = array
            }
            
            print(self.tableArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.tableArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
}

