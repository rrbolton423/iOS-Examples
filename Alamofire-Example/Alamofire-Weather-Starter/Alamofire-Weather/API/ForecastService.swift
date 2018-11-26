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
    let forecastAPIKey: String
    let forecastBaseUrl: URL?
    
    init(APIKey: String)
    {
        self.forecastAPIKey = APIKey
        forecastBaseUrl = URL(string: "https://api.darksky.net/forecast/\(APIKey)")
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void)
    {
        if let forecastURL = URL(string: "\(forecastBaseUrl!)/\(latitude),\(longitude)") {
            print(forecastURL)

            Alamofire.request(forecastURL).responseJSON { (response) in
            
                if let jsonDictionary = response.result.value as? [String:Any]
                {
                    if let currentWeatherDictionary = jsonDictionary["currently"] as? [String:Any]
                    {
                        let currrentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
                        completion(currrentWeather)
                    }
                    else
                    {
                        completion(nil)
                    }
                }
            }
        }
    }
}
