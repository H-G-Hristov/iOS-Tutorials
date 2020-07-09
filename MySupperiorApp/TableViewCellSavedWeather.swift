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
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeCell(savedWeatherData: SavedWeatherData) {
        self.imageViewWeather.image = UIImage(named: savedWeatherData.imageName)
        
        self.labelLocationName.text = savedWeatherData.weatherData.locationName
        
        self.labelCountry.text = savedWeatherData.weatherData.country
        
        let temperature = savedWeatherData.weatherData.temperature - 273
        self.labelTemperature.text = "\(temperature)°C"
    }
}
