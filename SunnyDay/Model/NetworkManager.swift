//
//  NetworkManager.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 16/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate: class {
    func updateInteface (_:NetworkManager, with currentWeather: CurrentWeather)
}

class NetworkManager {
    
    var delegate: NetworkManagerDelegate?
    
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.JSONdecoder(withData: data){
                    self.delegate?.updateInteface(self, with: currentWeather)
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
        }
        return nil
    }
}
