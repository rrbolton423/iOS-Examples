//
//  ViewController.swift
//  Realm-Example
//
//  Created by Romell Bolton on 11/30/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import RealmSwift // Import Realm

// Have VC implement UITableViewController
class ViewController: UITableViewController {
    
    // Get a reference to the TableView in the VC
    @IBOutlet var todoTableView: UITableView!
    
    // The "Results" object is a Realm list
    // In the generic you define the type of items the list can hold (ToDo)
    var todos: Results<ToDo>?
    
    // Create a Realm instance
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Return a list of "ToDo's" from Realm and save it the the "todos" array
        todos = realm.objects(ToDo.self)
        
        // Set the delegate and datasource to this VC (self)
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        // Reload the TableView
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Reload the TableView whenever this VC appears
        reload()
    }
    
    // Called before a segue is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If it is a "CellClick" segue...
        if segue.identifier == "CellClick" {
            
            // Get a reference to the destination VC (InsertViewController)
            let destination = segue.destination as! InsertViewController
            
            // Get the correct todo using the index path variable
            guard let todo = todos?[(todoTableView.indexPathForSelectedRow?.row)!] else {
                return
            }
            
            // Pass the todo to the destination VC
            destination.incomingTodo = todo
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a Todo
        guard let todo = todos?[indexPath.row] else {
            return UITableViewCell()
        }
        
        // Create a ToDoCell using the appropriate index path
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
    
        // Configure the text on the Cell using the Todo item
        cell.toDoLabel.text = todo.toDoText
        cell.isDoneLabel.text = String(todo.isDoneText ? "It is done" : "Do it")
        
        // Return the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows
        return todos?.count ?? 0
    }
    
    func reload() {
        
        // Reload the TableView's data
        tableView.reloadData()
    }
    
    // Handle deletion in the TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If the editing style is a delete
        if editingStyle == .delete {
            
            // Delete the selected Realm object given the index path
            try! realm.write {
                realm.delete((todos?[indexPath.row])!)
            }
            
            // Refresh the TableView
            reload()
        }
    }

}

 // Create Realm object that can be saved and pulled from a Realm DB
 // Must implement Object
class ToDo: Object {
    
    // Define Realm object properties
    @objc dynamic var toDoText = ""
    @objc dynamic var isDoneText: Bool = false
}

 // Create our own TableViewCell
class ToDoCell: UITableViewCell {

    // Get a reference to the labels in the ToDoCell
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var isDoneLabel: UILabel!
}

