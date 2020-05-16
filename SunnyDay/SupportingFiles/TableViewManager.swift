//
//  TableViewManager.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 16/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class cityTableView: UITableView {
    
    var testCityList = [
           City(name:"Sochi", temperature: 20, weatherIcon: "cloud.rain", cityID: 2626262, isFavorite: true),
           City(name:"Sochi", temperature: 20, weatherIcon: "cloud.rain", cityID: 2626262, isFavorite: true),
           City(name:"Sochi", temperature: 20, weatherIcon: "cloud.rain", cityID: 2626262, isFavorite: true)
       ]
    var cityList:[CurrentWeather] = []
}
