//
//  CellTableViewCell.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 7.07.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import UIKit

class TableViewCellSavedWeather: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var imageViewWeather: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeCell(weatherData: WeatherData) -> Bool {
        guard let savedWeatherData = SavedWeatherData(weatherData: weatherData) else {
            return false
        }
        
        imageViewWeather.image = UIImage(named: savedWeatherData.imageName)
        labelLocationName.text = savedWeatherData.weatherData.locationName
        labelCountry.text = savedWeatherData.weatherData.country
        
        let temperature = savedWeatherData.weatherData.temperature - 273
        labelTemperature.text = String(format: "%.2f°C", temperature)
        
        return true
    }
}
