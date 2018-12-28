//
//  LoginViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // Declare UI
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // When the View appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If there is a current user already logged in
        if let _ = Auth.auth().currentUser {
            
            // Sign in
            self.signIn()
        }
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        
        // Get the email and password from the UI
        let email = emailField.text
        let password = passwordField.text
        
        // Sign in with the email and password provided
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            
            // If there is a user returned
            guard let _ = user else {
                
                // If there is an error
                if let error = error {
                    
                    // Retrieve the error code
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        // Switch on the error code
                        switch errCode {
                            
                        // If the user is not found, display appropriate message
                        case .userNotFound:
                            self.showAlert("User account not found. Try registering")
                            
                        // If the password is incorrect, display appropriate message
                        case .wrongPassword:
                            self.showAlert("Incorrect username/password combination")
                            
                        // If it is another error, display it's information
                        default:
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                    
                    // Return
                    return
                }
                
                // Assert and exit method
                assertionFailure("user and error are nil")
                return
            }
            // If there is no error returned, sign the user in
            self.signIn()
        }
        
    }
    
    // This method allows the password reset for a user
    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        
        // Create prompt alert
        let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
        
        // Add ok action
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            // Get the input from the first text field of the Alter
            let userInput = prompt.textFields![0].text
            
            // If the field is empty...
            if (userInput!.isEmpty) {
                
                // Return from the method
                return
            }
            
            // Send a password reset to the given email
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                
                // If there was an error
                if let error = error {
                    
                    // Get the error code
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        
                        // Switch on the error code
                        switch errCode {
                            
                        // If the user was not found...
                        case .userNotFound:
                            
                            // Get on the main thread
                            DispatchQueue.main.async {
                                
                                // Display appropriate alert
                                self.showAlert("User account not found. Try registering")
                            }
                            
                        // In any other error case...
                        default:
                            
                            // Get on the main thread
                            DispatchQueue.main.async {
                                
                                // Display the error
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return // Return after handling error
                    
                } else { // If there is no error
                    
                    // Get on the main thread
                    DispatchQueue.main.async {
                        
                        // Display success alert
                        self.showAlert("You'll receive an email shortly to reset your password")
                    }
                }
            })
        }
        
        // Add text field to alert
        prompt.addTextField(configurationHandler: nil)
        
        // Add the okAction to the alert
        prompt.addAction(okAction)
        
        // Present the alert
        present(prompt, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        
        // Create UIAlertController, passing the message
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: .alert)
        
        // Add dismiss action to alert
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        
        // Go to the VC after successfully logging in
        performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }
    
}
