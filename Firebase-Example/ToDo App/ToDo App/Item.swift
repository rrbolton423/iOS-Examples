//
//  Item.swift
//  ToDo App
//
//  Created by Romell Bolton on 12/27/18.
//  Copyright © 2018 Echessa. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Model class
class Item {
    
    //  A FIRDatabaseReference represents a particular location in your Firebase Database and can be used for reading or writing data to that Firebase Database location.
    var ref: DatabaseReference?
    
    // Every Item has title property of type String
    var title: String?
    
    // Initialize Item with instance of DataSnapshot
    init (snapshot: DataSnapshot) {
        
        // Persist the snapshot
        ref = snapshot.ref
        
        // Cast the data as a String to String Dictionary
        let data = snapshot.value as! [String: String]
        
        // Persist the Item title after getting it from the 'data' dicitonary and casting it as a String
        title = data["title"]! as String
    }
}
