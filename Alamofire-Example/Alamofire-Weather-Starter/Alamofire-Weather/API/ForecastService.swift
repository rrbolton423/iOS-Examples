//
//  ForecastService.swift
//  Alamofire-Weather
//
//  Created by Romell Bolton on 11/21/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import Foundation
import Alamofire

class ForecastService
{
    // Sample url: https://api.darksky.net/forecast/33c371344898311931ea3058dcc4730f/37.8267,-122.4233
    
    // Declare API Key, and Base URL
    let forecastAPIKey: String
    let forecastBaseUrl: URL?
    
    // Initialize ForecastService class with APIKey
    init(APIKey: String)
    {
        // Perisist API Key
        self.forecastAPIKey = APIKey
        
        // Construct Forecast URL with API Key passed into the initializer
        forecastBaseUrl = URL(string: "https://api.darksky.net/forecast/\(APIKey)")
    }
    
    // Must provide the latitude and longitude of the location to retrieve a CurrentWeather object from the method
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void)
    {
        
        // Construct the forecast URL using the base, api key, and latitude & longitud
        if let forecastURL = URL(string: "\(forecastBaseUrl!)/\(latitude),\(longitude)") {

            // Create an Alamofire Request, passing the forecast url, recieving back a response object in a closure
            Alamofire.request(forecastURL).responseJSON { (response) in
            
                // If the Alamofire request returns a jsonDictionary of type [String:Any]
                if let jsonDictionary = response.result.value as? [String:Any]
                {
                    
                    // Drill into the "currently" array in the dictionary
                    if let currentWeatherDictionary = jsonDictionary["currently"] as? [String:Any]
                    {
                        
                        // Instantiate a CurrentWeather object using the json (currentWeatherDictionary)
                        let currrentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
                        
                        // Call the completion handler, passing the CurrentWeather object
                        completion(currrentWeather)
                        
                    } else { // Otherwise
                        
                        // Call the completion handler, passing nil
                        completion(nil)
                    }
                }
            }
        }
    }
}
