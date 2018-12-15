//
//  NetworkHandler.swift
//  SwiftyJSON
//
//  Created by Romell Bolton on 12/15/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import Foundation
import Alamofire // Import Alamofire
import SwiftyJSON // Import SwiftyJSON

class NetworkingAPI {
    
    // Singleton pattern
    static let sharedInstance = NetworkingAPI()
    private init() {}
    
    // This method downloads the JSON using Alamofire, and parses it into a JSON object using the SwiftyJSON "JSON()" constructor
    func getJSON(completionHandler: @escaping (_ json: JSON?, _ error: NSError?) -> Void) {
        
        // Download JSON data using Alamofire passing a URL
        Alamofire.request("http://api.nytimes.com/svc/topstories/v1/business.json?api-key=f4bf2ee721031a344b84b0449cfdb589:1:73741808").responseData { (response) in
            
            // Switch on the response
            switch(response.result) {
               
                // If the response is successful...
            case .success( _):
                
                // Create a SwiftyJSON Json object, passing the downloaded data
                let json = JSON(response.result.value!)
                
                // Pass the json object to the completion handler
                completionHandler(json, nil)
                
                // If the response is un-successful...
            case .failure(let error):
                
                // Pass the error object to the completion handler
                completionHandler(nil, error as NSError)
            }
        }
    }
}
