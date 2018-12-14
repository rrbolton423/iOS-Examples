//
//  Sweet.swift
//  firestoreapp
//
//  Created by Romell Bolton on 12/13/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import Foundation
import FirebaseFirestore

// Protocol to initialize the struct
protocol DocumentSerializable {
    init?(dictionary:[String:Any], id: String)
}

// Model type
struct Sweet {
    var name: String
    var content: String
    var timeStamp: Date
    var id: String
    
    // Dictionary computed property
    var dictionary: [String:Any] {
        return [
            "name": name,
            "content": content,
            "timeStamp": timeStamp
        ]
    }
}

extension Sweet: DocumentSerializable {

    // Contructor recieves a String:Any Dictionary
    init?(dictionary: [String : Any], id: String) {
        guard let name = dictionary["name"] as? String,
            let content = dictionary["content"] as? String,
            let timeStamp = dictionary["timeStamp"] as? Date else { return nil }
        
        // Parse the dictionary and construct a Sweet object using the default constructor
        self.init(name: name, content: content, timeStamp: timeStamp, id: id)
        
    }
}



