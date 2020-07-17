//
//  SavedWeatherData.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 7.07.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation
import UIKit

class SavedWeatherData {
    
    //MARK: Properties
    
    var imageName: String
    var weatherAttributedText: NSAttributedString?
    var weatherText: String
    var weatherType: WeatherType
    var weatherData: WeatherData
    
    // Failable initializer
    init? (weatherData: WeatherData) {
        self.weatherData = weatherData
        
        self.weatherType = SavedWeatherData.getWeatherType(weatherData: self.weatherData)
        self.imageName = SavedWeatherData.getWeatherImageName(weatherType: self.weatherType)
        
        self.weatherText = SavedWeatherData.buildHtml(weatherData: self.weatherData)
        self.weatherAttributedText = SavedWeatherData.getWeatherAsAttributedString(weatherText: self.weatherText)
        
    }
    
    static func buildHtml(weatherData: WeatherData) -> String {
        let degreesInCelsius = weatherData.temperature - 273
        let temperature = String(format: "%.2f", degreesInCelsius)
        let weatherCssStyles =
        """
                body {
                  text-indent: 50px;
                }
                .location {
                  font-size: 24px;
                  font-family: -apple-system;
                  font-weight: bolder;
                  /*font-stretch: ultra-expanded;*/
                  color: darkred;
                  text-shadow: 0px 0px 5px #FF9;
                  -webkit-font-smoothing: antialiased;
                }
                .country {
                  font-size: 18px;
                  font-family: -apple-system;
                  /*font-stretch: ultra-expanded;*/
                  font-style: italic;
                  color: lightred;
                  text-shadow: 0px 0px 5px #FF9;
                  -webkit-font-smoothing: antialiased;
                }
                .temperature {
                  font-size: 36px;
                  font-family: -apple-system;
                  /*font-stretch: ultra-expanded;*/
                  color: darkblue;
                  text-shadow: #fff 0px 0px 5px #FF9;
                  -webkit-font-smoothing: antialiased;
                }
        """
        let weatherText =
        """
        <html>
        <style type="text/css">
        \(weatherCssStyles)
        </style>
        <body>
        <div>
        <div>&nbsp;&nbsp;<span class="location">\(weatherData.locationName)</span></div>
        <div>&nbsp;&nbsp;<span class="country">\(weatherData.country)</span></div>
        <!--<div>\(temperature)°C</div>-->
        <div>&nbsp;&nbsp;<span class="temperature">\(temperature)&#176;C</span></div>
        </div>
        </body>
        </html>
        """
        
        return weatherText
    }
    
    static func getWeatherType(weatherData: WeatherData) -> WeatherType {
        switch (weatherData.temperature) {
        case 0 ..< 273:
            return WeatherType.Stormy
        case 273 ..< (273 + 10):
            return WeatherType.Cloudy
        case (273 + 10) ..< (273 + 20):
            return WeatherType.Rainy
        default:
            return WeatherType.Sunny
        }
    }
    
    static func getWeatherImageName(weatherType: WeatherType) -> String {
        switch(weatherType) {
        case WeatherType.Cloudy:
            return "cloudy.png"
        case WeatherType.Rainy:
            return "rainy.png"
        case WeatherType.Stormy:
            return "thunder-storm.png"
        case WeatherType.Sunny:
            return "sunny.png"
        }
    }
    
    static func getWeatherAsAttributedString(weatherText: String) -> NSAttributedString? {
        let data = Data(weatherText.utf8)
        let attributedString = try? NSAttributedString(
            data: data, options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        return attributedString
    }
}
