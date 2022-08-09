//
//  WeatherManager.swift
//  Clima
//
//  Created by OBS 53 on 04/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var weatherURI = "https://api.openweathermap.org/data/2.5/weather?appid=4be83306c5d3deb1d8d5eba3a76b39cf&&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURI)&q=\(cityName)"
        
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURI)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        // Create URL
        if let url = URL(string: urlString){
            // Create a URL session
            let session = URLSession(configuration: .default)
            // Give Session a Task
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            // Start the Task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decode = JSONDecoder()
        
        do {
            let decodedData = try decode.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(id: id, name: name, temp: temp)
            return weather
        }
        catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
