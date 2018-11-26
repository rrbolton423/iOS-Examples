//
//  CurrentWeatherViewController.swift
//  Alamofire-Weather
//
//  Created by Romell Bolton on 11/21/18.
//  Copyright © 2018 Duc Tran. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var temperatureScaleLabel: UILabel!
    
    let forecastAPIKey = "781df3f1eb4dc996bbde38ba9620e119"
    let coordinate: (lat: Double, long: Double) = (41.8781, 87.6298)
    var forecastService: ForecastService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getCurrentWeather(latitude: coordinate.lat, longitude: coordinate.long) { (currentWeather) in
            
            if let currentWeather = currentWeather {
                DispatchQueue.main.async {
                    if let temperature = currentWeather.temperature {
                        self.temperatureLabel.text = "\(temperature)°"
                        print(temperature)
                    } else {
                        self.temperatureLabel.text = "-"
                    }
                }
            }
        }
    }
}
