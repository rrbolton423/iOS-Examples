//
//  ViewController.swift
//  UserDefaults
//
//  Created by Romell Bolton on 12/14/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Declare Outlets
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dont load UserDefault data in viewDidLoad() due to crash if
        // UI / View has not apppeared yet
    }

    // IBAction for button click
    @IBAction func action(_ sender: Any) {
        
        // Display the 'name' input text
        outputLabel.text = inputTextField.text
        
        // Save the 'name' value input to UserDefaults using the key "myName"
        UserDefaults.standard.set(inputTextField.text, forKey: "myName")
        
        // Clear the TextField for new 'name' input
        inputTextField.text = ""
    }
    
    // Once the view has appeared...
    override func viewDidAppear(_ animated: Bool) {
        
        // Retrieve 'name' value from UserDefaults using the key "myName"
        if let name = UserDefaults.standard.object(forKey: "myName") as? String {
            
            // Display the input text 'name'
            outputLabel.text = name
        }
    }
    
}

