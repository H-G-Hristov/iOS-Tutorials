//
//  WeatherData.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 16.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation

enum WeatherType {
    case Cloudy
    case Rainy
    case Stormy
    case Sunny
}

struct JSONWeatherData : Codable {
    struct WorldCoordinates : Codable {
        var lon: Double
        var lat: Double
    }
    
    struct Forecast : Codable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct Main : Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int64
        var humidity: Int64
    }
    
    struct Wind : Codable {
        var speed: Double
        var deg: Int64
    }
    
    struct Clouds : Codable {
        var all: Int64
    }
    
    struct Sys : Codable {
        var type: Int64
        var id: Int64
        var country: String
        var sunrise: Int64
        var sunset: Int64
    }
    
    var coord : WorldCoordinates
    var weather: [Forecast]
    var base: String
    var main: Main
    var visibility: Int64
    var wind: Wind
    var clouds: Clouds
    var dt: Int64
    var sys: Sys
    var timezone: Int64
    var id: Int64
    var name: String
    var cod: Int64
}

struct WeatherData {
    var locationName: String
    var country: String
    var temperature: Float
    var humidity: Int8
    var pressure: Int64
    var windSpeed: Float
}

class WeatherDataOnlineManager {
    
    private let openweathermapApiKey = "3ff7ff964d3f5ba83fce768b7068a138"
    private let baseUrlString = "api.openweathermap.org/data/2.5/weather?q="
    
    private let jsonDecoder = JSONDecoder()
    private let viewController : ViewController
    
    init (viewController: ViewController) {
        self.viewController = viewController
    }
    
    private func buildUrl(locationName: String, countryCode: String?) -> URL {
        let location = locationName + ((nil != countryCode) ? ",\(countryCode!)" : "")
        let urlString = "https://\(baseUrlString)\(location)&appid=\(openweathermapApiKey)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        return NSURL(string: urlString)! as URL
    }
    
    private func makeWeatherDataCurrent(jsonData: JSONWeatherData) -> WeatherData {
        return WeatherData(
            locationName: jsonData.name,
            country: jsonData.sys.country,
            temperature: Float(jsonData.main.temp),
            humidity: Int8(jsonData.main.humidity),
            pressure: Int64(jsonData.main.humidity),
            windSpeed: Float(jsonData.main.pressure)
        )
    }
    
    private func getWeatherType(weatherData: WeatherData) -> WeatherType {
        switch (weatherData.temperature)
        {
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
    
    private func handleData(data: Data?)
    {
        let dataString = String(data: data!, encoding: String.Encoding.utf8)
        
        print("Human-readable data:\n\(dataString!)")
        
        do {
            let jsonData = try self.jsonDecoder.decode(JSONWeatherData.self, from: data!)
            let weatherData = self.makeWeatherDataCurrent(jsonData: jsonData)
            
            print("JSON data: \(jsonData)")
            print("Current weather data: \(weatherData)")
            
            // ViewController methods need to be called on the main thread async
            DispatchQueue.main.async {
                let weatherType = self.getWeatherType(weatherData: weatherData)
                self.viewController.changeViewColor(weatherType: weatherType)
                let degreesInCelsius = weatherData.temperature - 273
                let temperature = String(format: "%.2f", degreesInCelsius)
                let weatherText =
                """
                \(weatherData.locationName)
                \(weatherData.country)
                \(temperature)°C
                """
                self.viewController.labelCurrentWeather.text = weatherText
            }
        }
        catch {
            self.handleError(error: error)
        }
    }
    
    private func handleError(error: Error?)
    {
        // ViewController methods need to be called on the main thread async
        DispatchQueue.main.async {
            self.viewController.showToast(message: "Error receiving data from server: \(String(describing: error))")
        }
    }
    
    func requestData(locationName: String, countryCode: String) {
        let weatherRequestURL: URL = buildUrl(locationName: locationName, countryCode: countryCode)
        
        // Default session uses: GET
        let session = URLSession(configuration: .default)
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with : weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                // Case 1: Error - Got error while trying to get the data from the server
                self.handleError(error: error)
            }
            else {
                // Case 2: Success - Got a response from the server
                self.handleData(data:data)
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}
