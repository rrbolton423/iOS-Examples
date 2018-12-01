//
//  InsertViewController.swift
//  Realm-Example
//
//  Created by Romell Bolton on 11/30/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit
import RealmSwift

class InsertViewController: UIViewController {
    
    // Set up the possible incoming todo
    var incomingTodo: ToDo? = nil
    
    // Create a connection to Realm
    let realm = try! Realm()
    
    // Create IBOutlets for this VC
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var todoSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there is an existing todo object in this VC... add it to the UI
        if let goodToDo = incomingTodo {
            
            // Update the existing todo text
            todoTextField.text = goodToDo.toDoText
            
            // Update the existing todo switch
            todoSwitch.isOn = Bool(goodToDo.isDoneText)
        }
    }
    
    // Action when the save button is clicked
    @IBAction func saveButtonAction(_ sender: Any) {
        
        // If there is an existing todo object in this VC... update it
        if let goodToDo = incomingTodo {
            
            // Unwrap the todo TextField
            if let todoText = todoTextField.text {
                
                // Create a Realm transaction
                try! realm.write {
                    
                    // Set the Todo's text to the value in the TextField
                    goodToDo.toDoText = todoText
                    
                    // Set the Todo's isDone text to the value of the switch
                    goodToDo.isDoneText = todoSwitch.isOn
                }
            }
            
        } else { // If there isn't an existing todo object in this VC... create a new one
            
            // If there is no new text after clicking save, leave the method. Don't add empty Todo to Realm DB
            guard let todoText = todoTextField.text else { return }
            if todoText == "" { return }
            
            // Create a Realm ToDo object
            let todo = ToDo()
            
            // Set the Todo's text to the value in the TextField
            todo.toDoText = todoText
            
            // Set the Todo's isDone text to the value of the switch
            todo.isDoneText = todoSwitch.isOn
            
            // Create a Realm transaction
            try! realm.write {
                
                // Add the Todo Realm object to the Realm DB
                realm.add(todo)
            }
        }
        
        // Navigate to the previous View Controller
        navigationController?.popViewController(animated: true)
    }
    
    // Before the VC dissapears...
    override func viewWillDisappear(_ animated: Bool) {
        
        // Save the data
        self.saveButtonAction("Any")
    }
}
