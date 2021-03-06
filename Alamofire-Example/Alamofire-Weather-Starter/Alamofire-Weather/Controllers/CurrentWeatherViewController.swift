//
//  CurrentWeatherViewController.swift
//  Alamofire-Weather
//
//  Created by Romell Bolton on 11/21/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    // Create VC Views
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperatureScaleLabel: UILabel!
    
    // Testing Data; API Key and Coordinates for Chicago, IL
    let forecastAPIKey = "781df3f1eb4dc996bbde38ba9620e119"
    let coordinate: (lat: Double, long: Double) = (41.8781, -87.6298)
    
    // Declare a ForecastService object to get the weather data
    var forecastService: ForecastService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the ForecastService object with the API Key
        forecastService = ForecastService(APIKey: forecastAPIKey)
        
        // Get the forecast using the ForecastService, also passing a latitude and longitude of a location. This method returns a currentWeather object in a closure
        forecastService.getCurrentWeather(latitude: coordinate.lat, longitude: coordinate.long) { (currentWeather) in
            
            // OFF THE MAIN QUEUE!!!!

            // Unwrap the currentWeather object
            if let currentWeather = currentWeather {
                
                // Display data on the main thread
                DispatchQueue.main.async {
                    
                    // RULE: ALL UI CODE MUST HAPPEN ON THE MAIN QUEUE
                    
                    // If temperature is not nil...
                    if let temperature = currentWeather.temperature {
                        
                        // Display temperature in the VC's label
                        self.temperatureLabel.text = "\(temperature)°"
                        
                    } else { // If temperature is nil...
                        
                        // Display a placeholder in the VC's label
                        self.temperatureLabel.text = "-"
                    }
                }
            }
        }
    }
}
