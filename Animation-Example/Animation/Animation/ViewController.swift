//
//  ViewController.swift
//  Animation
//
//  Created by Romell Bolton on 12/22/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Reference to UIView to be animated
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Action method for button click
    @IBAction func animate(_ sender: Any) {

        // UIView's animate() method: Animate changes to one or more views using the specified duration and completion handler.
        UIView.animate(withDuration: 1, animations: {
            
            // Change the View's color to brown
            self.animationView.backgroundColor = .brown
            
            // Increase the width of the view by 10
            self.animationView.frame.size.width += 10
            
            // Increase the height of the view by 10
            self.animationView.frame.size.height += 10
            
        }) { _ in // in the closure, run another animation after completing the first one above
            
            // Repeat the animation back and forth
            // .autoreverse: Run the animation backwards and forwards (must be combined with the repeat option).
            // .repeat: Repeat the animation indefinitely.
            UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                
                // View will slide up and slide back down indefinitely due to .autoreverse and .repeat options
                self.animationView.frame.origin.y -= 20
            })
        }
    }
    
}

