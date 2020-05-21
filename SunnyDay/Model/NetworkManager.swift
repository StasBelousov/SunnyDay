//
//  NetworkManager.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 16/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation
import CoreLocation

protocol NetworkManagerDelegate: class {
    func updateInteface (_:NetworkManager, with currentWeather: CurrentWeather)
}

class NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    
    var currentWeatherData:[CurrentWeather] = []
    
    enum RequestType {
        case cityName(city:String)
        case coordinate(latitude: CLLocationDegrees, longitude:CLLocationDegrees)
    }
    
    func fetchCurrentWeather(forRequestType requestType:RequestType, language:String) {
        var urlString = ""
        switch requestType {
        case .cityName(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric&lang=\(language)"
             print(urlString)
       case .coordinate(let latitude, let longitude):
                   urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&apikey=\(apiKey)&units=metric&lang=\(language)"
               }
               performRequest(withURLString: urlString)
           }
    
    fileprivate func performRequest(withURLString urlString: String) {
    guard let url = URL(string: urlString) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
        if let data = data {
            if let currentWeather = self.JSONdecoder(withData: data) {
                    self.delegate?.updateInteface(self, with: currentWeather)
                    self.saveWeatherData(weatherData: currentWeather)
                }
            }
        }
        task.resume()
    }
    
    func JSONdecoder(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()        
        do {
            let currentWeatherData = try decoder.decode(WeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
            print("!!!")
        }
        return nil
    }
    func saveWeatherData (weatherData: CurrentWeather) {
        currentWeatherData.append(weatherData)
    }
}
