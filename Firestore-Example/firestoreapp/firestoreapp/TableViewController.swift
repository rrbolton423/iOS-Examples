//
//  TableViewController.swift
//  firestoreapp
//
//  Created by Brian Advent on 02.10.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TableViewController: UITableViewController {
    
    // Declare Firestore DB
    var db: Firestore!
    
    // Initialize array of Sweets
    var sweetArray = [Sweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize DB
        db = Firestore.firestore()
        
        // Load data after DB intialization
        loadData()
        
        // Listens for updates while the app is running
        checkForUpdates()
    }
    
    func loadData() {
        
        // Retrieve all the documents from the "sweets" collection
        db.collection("sweets").getDocuments { (querySnaposhot, error) in
            
            // If there is an error
            if let error = error {
                
                // Print the error
                print("\(error.localizedDescription)")
                
            } else { // If there is no error
                
                // Add the Sweets from Firestore to the array
                // Convert the array of QuerySnapshots to an Array of Sweets
                // using compactMap
                self.sweetArray = querySnaposhot!.documents.compactMap({Sweet.init(dictionary: $0.data(), id: $0.documentID)})
                
                // User Interface update
                DispatchQueue.main.async {
                    
                    // Reload the TableView's data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // This method checks for updates to the Firestore DB while the app is running
    func checkForUpdates() {
        
        // Add a listener for changes on the "sweets" collection in the Firestore db
        db.collection("sweets").whereField("timeStamp", isGreaterThan: Date()).addSnapshotListener { (querySnaposhot, error) in
            
            // Check if we get a snapshot back
            guard let snapshot = querySnaposhot else { return }
            
            // Get an array of the documents that changed since the last snapshot
            snapshot.documentChanges.forEach { diff in
                
                // If the change was an "ADD"
                if diff.type == .added {
                    
                    // Append the Sweet to the array
                    self.sweetArray.append(Sweet.init(dictionary: diff.document.data(), id: diff.document.documentID)!)
                    
                    // User Interface update
                    DispatchQueue.main.async {
                        
                        // Reload the TableView's data
                        self.tableView.reloadData()
                    }
                    
                } else if diff.type == .removed {
                    
                    // Append the Sweet to the array
                    //self.sweetArray.remove(Sweet.init(dictionary: diff.document.data())!)
                    
                    // User Interface update
                    DispatchQueue.main.async {
                        
                        // Reload the TableView's data
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    // This method adds Sweets to the Firestore DB
    @IBAction func composeSweet(_ sender: Any) {
        
        // Create UIAlertController to add Sweets
        let composeAlert = UIAlertController(title: "New Sweet", message: "Enter your name and message", preferredStyle: .alert)
        
        // Add name TextField with placeholder
        composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your name"
        }
        
        // Add message TextField with placeholder
        composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your message"
        }
        
        // Add CANCEL action to Alert
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add SEND action to Alert, with closure following implementation
        composeAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            
            // INTERESTING PART
            
            // Get data from UI
            if let name = composeAlert.textFields?.first?.text, let content = composeAlert.textFields?.last?.text {
                
                // Create a new Sweet using the data
                var newSweet = Sweet.init(name: name, content: content, timeStamp: Date(), id: "")
                // Add a Document with some data
                
                // Declare a Document reference, which generates a document ID automatically
                var ref: DocumentReference? = nil
                
                // Assign the Document a collection "Sweets", adding the document containing the data from the Sweet
                ref = self.db.collection("sweets").addDocument(data: newSweet.dictionary) { error in
                    
                    // If there is an error...
                    if let error = error {
                        
                        // Print error
                        print("Error adding document: \(error.localizedDescription)")
                        
                    } else { // Else...
                        
                        // Print Document ID
                        print("Document added with ID: \(ref!.documentID)")
                        
                        // Assign the id to the Sweet
                        newSweet.id = (ref?.documentID)!
                    }
                }
            }
            
        }))
        
        // Present the Alert
        self.present(composeAlert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // Return 1 section
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of Sweets in the array
        return sweetArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a UITableViewCell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Get a Sweet using the Index path
        let sweet = sweetArray[indexPath.row]
        
        // Configure the Data on the Cell
        cell.textLabel?.text = "\(sweet.name): \(sweet.content)"
        cell.detailTextLabel?.text = "\(sweet.timeStamp)"
        
        // Return the Cell
        return cell
    }
    
    // Tell the TableView that it can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle the TableView's editing style
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If something is about to be deleted from the TableView...
        if editingStyle == .delete {
           
            // 2. Now Delete the Child from the database
            let sweet = sweetArray[indexPath.row]
            
            // Delete the selected document
            db.collection("sweets").document(sweet.id).delete() { err in
                
                // If there is an error...
                if let err = err {
                    
                    // Print error
                    print("Error removing Sweet: \(err)")
                    
                } else { // Else...
                    
                    // Successful deletion!
                    print("Sweet successfully removed!")
                }
            }
            
        }
        
        // Remove the sweet from the array property
        self.sweetArray.remove(at: indexPath.row)
        
        // Delete the row from the TableView at the given IndexPath
        self.tableView.deleteRows(at: [indexPath], with: .automatic)

    }
    
}
