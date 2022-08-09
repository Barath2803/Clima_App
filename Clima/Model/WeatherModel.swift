//
//  WeatherModel.swift
//  Clima
//
//  Created by OBS 53 on 05/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let id: Int
    let name: String
    let temp: Double
    
    var temperatureString: String {
        return String(format: "%.1f",temp)
    }
    
    var conditionName: String{
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...633:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 800...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
