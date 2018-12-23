//
//  ViewController.swift
//  AutoLayout
//
//  Created by Romell Bolton on 12/22/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Declare UIView square to put on screen
    weak var square: UIView!
    
    override func viewDidLoad() {
        
        // Instantiate the square view
        let square = UIView()
        
        // Add the square view to the main view on screen
        self.view.addSubview(square)
        
        // Set to false in order to set constraints programmatically and not automatically
        square.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to the parent view
        self.view.addConstraints([
            
            // Constrain the square's width to be 64
            NSLayoutConstraint(item: square, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 64),
            
            // Constrain the square's height to be 64
            NSLayoutConstraint(item: square, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 64),
            
            // Constrain the center x of the square equal to the parent view's center x
            // Constrain to center of the screen
            NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0),
            
            // Constrain the center y of the square equal to the parent view's center y
            // Constrain to center of the screen
            NSLayoutConstraint(item: square, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
            ])
        
        // Persist the square view after adding the constraints
        self.square = square
        
        // Set the color of the square view to green
        self.square.backgroundColor = .green

    }
    
}

