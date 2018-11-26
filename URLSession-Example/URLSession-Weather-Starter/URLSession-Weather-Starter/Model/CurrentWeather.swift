//
//  CurrentWeather.swift
//  URLSession-Weather-Starter
//
//  Created by Romell Bolton on 11/26/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import Foundation

class CurrentWeather
{
    // Define properties for CurrentWeather object
    let temperature: Double?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    let icon: String?
    
    // Set up keys to easily parse the json and allow for changing in one place
    struct WeatherKeys {
        static let temperature = "temperature"
        static let humidity = "humidity"
        static let precipProbability = "precipProbability"
        static let summary = "summary"
        static let icon = "icon"
    }
    
    //  Parse the weatherDictionary into a Current Weather object, setting it's stored properties using the WeatherKeys to access the values from the json
    init(weatherDictionary: [String : Any])
    {
        self.temperature = weatherDictionary[WeatherKeys.temperature] as? Double
        
        if let humidityDouble = weatherDictionary[WeatherKeys.humidity] as? Double {
            humidity = Int(humidityDouble * 100)
        } else {
            humidity = nil
        }
        
        if let precipDouble = weatherDictionary[WeatherKeys.precipProbability] as? Double {
            precipProbability = Int(precipDouble * 100)
        } else {
            precipProbability = nil
        }
        
        self.summary = weatherDictionary[WeatherKeys.summary] as? String
        self.icon = weatherDictionary[WeatherKeys.icon] as? String
    }
}
