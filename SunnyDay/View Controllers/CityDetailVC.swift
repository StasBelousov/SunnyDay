//
//  CityDetailVC.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 19/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit
import CoreLocation

class cityDetailVC: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var networkManager = NetworkManager()
    var locationCity:[CurrentWeather] = []
    var delegate: NetworkManagerDelegate?
    
    lazy var locationManager:CLLocationManager = {
        let location = CLLocationManager()
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyKilometer
        location.requestWhenInUseAuthorization()
        return location
    }()
    
    var city: String? {
        get { return cityLabel.text }
        set { cityLabel.text = newValue }
    }
    var temperature:String? {
        get { return temperatureLabel.text }
        set { temperatureLabel.text = newValue }
    }
    var weatherDescription: String? {
        get { weatherDescriptionLabel.text }
        set { weatherDescriptionLabel.text = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.delegate = self
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
}
extension cityDetailVC: NetworkManagerDelegate {
    func updateInteface(_: NetworkManager, with currentWeather: CurrentWeather) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.city = currentWeather.cityName
            self.temperature = currentWeather.temperatureString
            self.weatherDescription = currentWeather.description
            
        }
    }
}
// MARK: - CLLocationManagerDelegate

extension cityDetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude), language: "ru")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

