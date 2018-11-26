//
//  ForecastService.swift
//  URLSession-Weather-Starter
//
//  Created by Romell Bolton on 11/26/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import Foundation

class ForecastService
{
    // Declare API Key, and Base URL
    let forecastAPIKey: String
    let forecastBaseURL: URL?
    
    // Initialize ForecastService class with APIKey
    init(APIKey: String) {
        
        // Perisist API Key
        self.forecastAPIKey = APIKey
        
        // Construct Forecast URL with API Key passed into the initializer
        forecastBaseURL = URL(string: "https://api.darksky.net/forecast/\(APIKey)")
    }
    
    // Must provide the latitude and longitude of the location to retrieve a CurrentWeather object from the method
    func getForecast(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void)
    {
        // Construct the forecast URL using the base, api key, and latitude & longitude
        if let forecastURL = URL(string: "\(forecastBaseURL!)/\(latitude),\(longitude)") {

            // Create a NetworkProcessor object to download our data from the constrcuted URL
            let networkProcessor = NetworkProcessor(url: forecastURL)
            
            // Perform the download, getting back a jsonDictionary
            networkProcessor.downloadJSONFromURL { (jsonDictionary) in
                
                // Parse json into a swift weather object
                
                // Drill into the "currently" array in the dictionary
                if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String : Any] {
                    
                    // Instantiate a CurrentWeather object using the json (currentWeatherDictionary)
                    let currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
                    
                    // Call the completion handler, passing the CurrentWeather object
                    completion(currentWeather)
                    
                } else { // Otherwise...
                    
                    // Call the completion handler, passing nil
                    completion(nil)
                }
            }
        }
    }
}
