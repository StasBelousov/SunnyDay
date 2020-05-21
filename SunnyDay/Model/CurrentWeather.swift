//
//  CurrentWeather.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 16/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation


struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
  
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    let description: String
    
    init? (currentWeatherData: WeatherData) {
        
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        conditionCode = currentWeatherData.weather.first!.id
        description = currentWeatherData.weather.first!.weatherDescription
        
    }
    
}
