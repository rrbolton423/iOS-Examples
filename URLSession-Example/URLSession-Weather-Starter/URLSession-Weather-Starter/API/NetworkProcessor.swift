//
//  NetworkProcessor.swift
//  URLSession-Weather-Starter
//
//  Created by Romell Bolton on 11/26/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import Foundation

class NetworkProcessor
{
    
    // Get default URLSessionConfiguration
    // (lazy) - won't initiliaze a new instance until it is in use for the first time
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    
    // Initialize a URLSession variable with configuration
    // (lazy) - won't initiliaze a new instance until it is in use for the first time
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    // Define URL
    let url: URL
    
    // Must initialize class with URL
    init(url: URL) {
        
        // Persist URL to property of the class
        self.url = url
    }
    
    // Closure for JSON
    typealias JSONDictionaryHandler = (([String : Any]?) -> Void)
    
    // Method donwloads JSON from URL, and calls completion handler after the download finishes
    func downloadJSONFromURL(_ completion: @escaping JSONDictionaryHandler)
    {
        
        // Create URLRequest, passing the URL to the constructor
        let request = URLRequest(url: self.url)
        
        // Create DataTask to download Data
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // If there is no error
            if error == nil {
                
                // Unwrap the HTTPResponse
                if let httpResponse = response as? HTTPURLResponse {
                    
                    // Switch on the response
                    switch httpResponse.statusCode {
                        
                    // In the case of a successful response...
                    case 200 :
                        
                        // Get the data
                        if let data = data {
                            
                            do {
                                
                            // Create a json dictionary from the data
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                
                                // Call completion handler, passing back json dictionary
                                completion(jsonDictionary as? [String : Any])
                                
                            } catch let error as NSError { // Catch error
                                
                                // Print error
                                print("Error processing json data: \(error.localizedDescription)")
                            }
                        }
                        
                    // In the case of anything else...
                    default:
                        
                        // Print the response code
                        print("HTTP Response Code: \(httpResponse)")
                    }
                }
                
            } else { // If there is an error
                
                // Print error
                print("Error: \(error?.localizedDescription)")
            }
        }
        
        // Start the Data Task
        dataTask.resume()
    }
}
