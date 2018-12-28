//
//  ItemsTableViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import Firebase

class ItemsTableViewController: UITableViewController {
    
    // Represents a user
    var user: User!
    
    // Array of Item objects
    var items = [Item]()
    
    // Firebase Database reference
    //A FIRDatabaseReference represents a particular location in your Firebase Database and can be used for reading or writing data to that Firebase Database location
    var ref: DatabaseReference!
    
    // A FIRDatabaseHandle is used to identify listeners of Firebase Database events.
    private var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the current user since they have to be logged in to get to this VC
        user = Auth.auth().currentUser
        
        // Get a reference to the Firebase backend database
        ref = Database.database().reference()
        
        // Start observing the database when the VC appears
        startObservingDatabase()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Return the number of sections in the TableView
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of Items in the array
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Get the given item
        let item = items[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = item.title
        
        // Return the given cell
        return cell
    }
    
    // This method deletes items from the Firebase database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If the editing style is a deletion...
        if editingStyle == .delete {
            
            // Get the to be deleted item
            let item = items[indexPath.row]
            
            // Remove the value from the database
            item.ref?.removeValue()
        }
    }
    
    // This method signs the user out
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        
        // Try to...
        do {
            
            // Sign the user out
            try Auth.auth().signOut()
            
            // Go back to the login screen after signing out
            performSegue(withIdentifier: "SignOut", sender: nil)
            
            // Catch the error
        } catch let error {
            
            // Make assertion
            assertionFailure("Error signing out: \(error)")
        }
    }
    
    // This method adds an Item to the database
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        
        // Create prompt alert
        let prompt = UIAlertController(title: "To Do App", message: "To Do Item", preferredStyle: .alert)
        
        // Add ok action
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            // Get the input from the first text field of the Alert
            let userInput = prompt.textFields![0].text
            
            // If the field is empty...
            if (userInput!.isEmpty) {
                
                // Return from the method
                return
            }
            
            // Save the Item to the Firebase database
            self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
        }
        
        // Add text field to alert
        prompt.addTextField(configurationHandler: nil)
        
        // Add the okAction to the alert
        prompt.addAction(okAction)
        
        // Present the alert
        present(prompt, animated: true, completion: nil);
        
    }
    
    // This method retrieves data from the database in the form os a DataSnapshot
    func startObservingDatabase () {
        
        // Observe / retrieve values from the database at the specified path. Data is returned as a snapshot
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            
            // Create a local array of Items
            var newItems = [Item]()
            
            // Loop through the DataSnapshot's children
            for itemSnapShot in snapshot.children {
                
                // Create an Item from each snapshot in the initializer
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                
                // Add the new Item to the local 'newItems' array
                newItems.append(item)
            }
            
            // Persist the array of items using the local array to the property array 'items'
            self.items = newItems
            
            // Add the new items to the TableView for display, refresh the data
            self.tableView.reloadData()
            
        })
    }
    
    // Stop observing the database when the VC dissapears
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }
}
