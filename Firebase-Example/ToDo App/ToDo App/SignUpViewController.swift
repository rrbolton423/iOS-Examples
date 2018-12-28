//
//  SignUpViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        
        // Get the email and password from the UI
        let email = emailField.text
        let password = passwordField.text
        
        // Sign in with the email and password provided
        Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
            
            // If there is an error
            if let error = error {
                
                // Retrieve the error code
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    // Switch on the error code
                    switch errCode {
                        
                    // If the email is invalid, display appropriate message
                    case .invalidEmail:
                        self.showAlert("User account not found. Try registering")
                        
                    // If the email is already in use, display appropriate message
                    case .emailAlreadyInUse:
                        self.showAlert("Incorrect username/password combination")
                        
                    // If it is another error, display it's information
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                
                // Return
                return
            }
            
            // If there is no error returned, sign the user in
            self.signIn()
        }
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
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
        performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
    }
}
