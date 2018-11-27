//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Romell Bolton on 11/25/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController
{
    // Define the Managed Object Context
    var managedObjectContext: NSManagedObjectContext!
    
    // Define an array of Entries (of type NSManagedObject)
    var entries: [NSManagedObject]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the title of the VC to "Journal"
        self.title = "Journal"
        
        // Get a reference to the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get a reference to the Managed Object Context
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Fetch the Entries whenever the View is loaded (multiple times)
        self.fetchEntries()
    }
    
    func fetchEntries()
    {
        // Create a Fetch Request to retrieve "Entry" entities
        // from the ManagedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            // Tell the ManagedObjectContext to execute the spcecified Fetch Request
            let entryObjects = try managedObjectContext.fetch(fetchRequest)
            
            // Persist the array of entries to the field of the class
            self.entries = entryObjects as? [NSManagedObject]
            
        } catch let error as NSError { // Catch Error
            
            // Print Error
            print("Could not fetch entries: \(error), \(error.userInfo)")
            
        }
        
        // Reload the TableView with the new data
        self.tableView.reloadData()
    }
    
    // MARK: - Target action
    
    @IBAction func composeDidClick(_ sender: AnyObject)
    {
        // Perform the Segue to Navigate to the Compose VC
        self.performSegue(withIdentifier: "Show Composer", sender: nil)
    }

    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // Return the number of sections in the TableView
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of entries
        return self.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Create a TableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Entry Cell", for: indexPath)
        
        // Get the specified Entry
        let entry = entries[indexPath.row]
        
        // Set the cell's text to the Entry's bodyText
        cell.textLabel?.text = entry.value(forKey: "bodyText") as? String

        // Get the Entry date
        let entryDate = entry.value(forKey: "createdAt") as! Date
        
        // Convert the Date into a TimeFormattedAsTimeAgo String
        cell.detailTextLabel?.text = dateTimeFormattedAsTimeAgo(entryDate)
        
        // Return the cell
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Don't show gray selection on table view row
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the selected Entry
        let entry = entries[indexPath.row]
        
        // Perform the specified Segue, passing the entry (NSManagedObject) as the sender
        self.performSegue(withIdentifier: "Show Composer", sender: entry)
    }
    
    // Tell the TableView that it can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle the TableView's editing style
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If something is about to be deleted from the TableView...
        if editingStyle == .delete {
            
            // Get the selected (to be deleted) entry using the given indexPath
            let entry = self.entries[indexPath.row]
            
            // Delete the entry from the ManagedObjectContext
            self.managedObjectContext.delete(entry)
            
            // Remove the entry from the array property
            self.entries.remove(at: indexPath.row)
            
            // Delete the row from the TableView at the given IndexPath
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                
                // Commit the save into the ManagedObjectContext
                try managedObjectContext.save()
                
            } catch let error as NSError { // Catch Error
                
                // Print Error
                print("Could not delete the existing entry: \(error.localizedDescription)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // If the segue is "Show Composer"...
        if segue.identifier == "Show Composer" {
            
            // Get a reference to the ComposeViewController
            let composeViewController = segue.destination as! ComposeViewController
            
            // Pass the selected entry to the ComposeViewController
            composeViewController.entry = sender as? NSManagedObject
        }
    }
    
}
