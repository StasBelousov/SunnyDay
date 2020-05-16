//
//  MainTableViewCell.swift
//  SunnyDay
//
//  Created by Станислав Белоусов on 16/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    func setCell(object:CurrentWeather) {
        self.cityName.text = object.cityName
        self.temperature.text = String(object.temperatureString)
        self.weatherIcon.image = UIImage(systemName: object.systemIconNameString)
    }
}


