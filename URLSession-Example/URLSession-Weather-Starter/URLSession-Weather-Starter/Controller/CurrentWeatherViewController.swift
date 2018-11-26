//
//  CurrentWeatherViewController.swift
//  URLSession-Weather-Starter
//
//  Created by Romell Bolton on 11/26/18.
//  Copyright © 2018 Romell Bolton. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    // Create VC Views
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureScaleLabel: UILabel!
    
    // Testing Data
    let forecastAPIKey = "33c371344898311931ea3058dcc4730f"
    let coordinate: (lat: Double, long: Double) = (41.8781, 87.6298)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of the ForecastService
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        
        // Get the forecast using the ForecastService
        forecastService.getForecast(latitude: coordinate.lat, longitude: coordinate.long) { (currentWeather) in
            
            // Unwrap the currentWeather object
            // OFF THE MAIN QUEUE!!!!
            if let currentWeather = currentWeather {
                // Display data on the main thread
                DispatchQueue.main.async {
                    
                    // RULE: ALL UI CODE MUST HAPPEN ON THE MAIN QUEUE
                    if let temperature = currentWeather.humidity {
                        self.temperatureLabel.text = "\(temperature)"
                    } else {
                        self.temperatureLabel.text = "-"
                    }
                }
            }
        }
    }
}
