//
//  ComposeViewController.swift
//  Journal
//
//  Created by Romell Bolton on 11/25/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import CoreData // Import CoreData

class ComposeViewController: UIViewController
{
    
    var managedObjectContext: NSManagedObjectContext!
    var entry: NSManagedObject!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compose"
        self.textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
        
        // Get a reference to the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get a reference to the Managed Object Context
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if entry != nil { // If there is an existing entry passed into this class...
            
            // Set the TextField to the existing Entry
            self.textView.text = entry.value(forKey: "bodyText") as? String
        
        } else { // If there is no entry, meaning the compose button was clicked...
    
            // Set the TextField to an empty String for a 'new' Entry
            self.textView.text = ""

        }

    }
    
    @IBAction func doneDidClick()
    {
        // If there is an existing Entry when the 'done' button is clicked...
        if entry != nil {
            
            // Update that Entry in CoreData
            self.updateEntry()
            
        } else { // If we haven't created an Entry yet...
            
            // If there is new text entered...
            if textView.text != "" {
                
                // Create a new Entry
                self.createNewEntry()
            }
        }
        
        // Go back to the Root View Controller (i.e EntriesTableViewController)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // createNewEntry() creates a 'new' NSManagedObject "Entry", and saves it
    // to CoreData
    func createNewEntry()
    {
        
        // Create a description of an entity in Core Data
        let entryEntity = NSEntityDescription.entity(forEntityName: "Entry", in: self.managedObjectContext)!
        
        // Create a new NSManagedObject to be inserted into the Managed Object Context,
        // under the entity description
        let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.managedObjectContext)
        
        // Configure the Entry object
        entryObject.setValue(self.textView.text, forKey: "bodyText")
        entryObject.setValue(NSDate(), forKey: "createdAt")

        do {
            
            // Commit the save into the ManagedObjectContext
            try managedObjectContext.save()
            
        } catch let error as NSError { // Catch Error
            
            // Print Error
            print("Could not save the new entry: \(error.localizedDescription)")
        }
    }
    
    // updateEntry() edits the existing NSManagedObject "Entry", and saves it
    // back to CoreData
    func updateEntry()
    {
        // If this method is called, the Entry is not nil, so we just edit it
        // Configure the Entry object
        entry.setValue(self.textView.text, forKey: "bodyText")
        entry.setValue(NSDate(), forKey: "createdAt")
        
        do {
            
            // Commit the save into the ManagedObjectContext
            try managedObjectContext.save()
            
        } catch let error as NSError { // Catch Error
            
            // Print Error
            print("Could not update the existing entry: \(error.localizedDescription)")
        }
    }
    
}

























