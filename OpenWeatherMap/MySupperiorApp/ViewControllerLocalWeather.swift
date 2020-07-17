//
//  ViewControllerLocalWeather.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 3.07.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation
import UIKit

import os.log

class ViewControllerLocalWeather: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var barButtonItemSave: UIBarButtonItem!
    @IBOutlet weak var imageViewLocalWeather: UIImageView!
    @IBOutlet weak var labelLocalWeather: UILabel!
    @IBOutlet weak var labelLocalWeatherHumidity: UILabel!
    @IBOutlet weak var labelLocalWeatherWindSpeed: UILabel!
    @IBOutlet weak var labelLoacalWeatherPressure: UILabel!
    
    var savedWeatherData: SavedWeatherData?
    
    // MARK: Initializers and delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard savedWeatherData != nil else {
            return
        }
        
        if let imageName = savedWeatherData?.imageName, let receivedImage = UIImage(named: imageName) {
            imageViewLocalWeather.image = receivedImage
        }
        if let receivedAttributedText = savedWeatherData?.weatherAttributedText {
            labelLocalWeather.attributedText = receivedAttributedText
        }
        
        let weatherData = savedWeatherData?.weatherData
        
        var humidityStr = String()
        if let humidity = weatherData?.humidity {
            humidityStr.append("\(humidity)%")
        }
        labelLocalWeatherHumidity.text = humidityStr
        
        var windSpeedStr = String()
        if var windSpeed = weatherData?.windSpeed {
            windSpeed /= 1000.0
            windSpeedStr.append("\(windSpeed) m/s")
        }
        labelLocalWeatherWindSpeed.text = windSpeedStr
        
        var pressureStr = String()
        if let pressure = weatherData?.pressure {
            pressureStr.append("\(pressure) kPa")
        }
        labelLoacalWeatherPressure.text = pressureStr
    }
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === barButtonItemSave else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            
            return
        }
        
        let viewController = segue.destination as! ViewController
        
        viewController.saveCurrentWeatherToTableView()
    }
    
}
