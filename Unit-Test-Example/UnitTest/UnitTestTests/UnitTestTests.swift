//
//  UnitTestTests.swift
//  UnitTestTests
//
//  Created by Romell Bolton on 12/15/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import XCTest // Import XCTest
@testable import UnitTest // Import project module

// Unit Test Case class
class UnitTestTests: XCTestCase {
    
    // Test function
    func testSquareInt() {
        
        // Define variable that contains 3
        let value = 3
        
        // Square the variable
        let squaredValue = value.square()
        
        // Assert that squared value is equal to 9
        XCTAssertEqual(squaredValue, 9)
    }

    // Test function
    func testHelloWorld() {
        
        // Declare nil String variable
        var helloWorld: String?
        
        // Assert that String is nil
        XCTAssertNil(helloWorld)
        
        // Assign String a non nil value of "hello world"
        helloWorld = "hello world"
        
        // Assert that the variable equals the value "hello world"
        XCTAssertEqual(helloWorld, "hello world")
    }

}
