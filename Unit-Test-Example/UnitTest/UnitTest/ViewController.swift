//
//  ViewController.swift
//  UnitTest
//
//  Created by Romell Bolton on 12/15/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(2.square())
    }


}

// Method to Unit Test
// Simple math square function
extension Int {
    func square() -> Int {
        return self * self
    }
}

