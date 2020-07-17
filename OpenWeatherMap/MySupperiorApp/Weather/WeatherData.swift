//
//  WeatherData.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 16.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation

import os.log

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

class WeatherData: NSObject, NSCoding {
    
    // MARK: Properties
    
    public var locationName: String
    public var country: String
    public var temperature: Float
    public var humidity: Int64
    public var pressure: Int64
    public var windSpeed: Float
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("weatherData")
    
    // MARK: Initializers
    
    init(locationName: String,
         country: String,
         temperature: Float,
         humidity: Int64,
         pressure: Int64,
         windSpeed: Float) {
        self.locationName = locationName
        self.country = country
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        self.windSpeed = windSpeed
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        guard let locationName = aDecoder.decodeObject(forKey: WeatherDataPropertyKey.locationName) as? String else {
            os_log("Unable to decode WeatherData.locationName", log: OSLog.default, type: .debug)
            return nil
        }
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        guard let country = aDecoder.decodeObject(forKey: WeatherDataPropertyKey.country) as? String else {
            os_log("Unable to decode WeatherData.country", log: OSLog.default, type: .debug)
            return nil
        }
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        let temperature = aDecoder.decodeFloat(forKey: WeatherDataPropertyKey.temperature)
        
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        let humidity = aDecoder.decodeInt64(forKey: WeatherDataPropertyKey.humidity)
        
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        let pressure = aDecoder.decodeInt64(forKey: WeatherDataPropertyKey.pressure)
        
        // The locationName is required. If we cannot decode a locationName string, the initializer should fail.
        let windSpeed = aDecoder.decodeFloat(forKey: WeatherDataPropertyKey.windSpeed)
        
        self.init(locationName:locationName,
                  country:country,
                  temperature:temperature,
                  humidity:humidity,
                  pressure:pressure,
                  windSpeed:windSpeed)
    }
    
    // MARK: Methods
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: WeatherDataPropertyKey.locationName)
        aCoder.encode(country, forKey: WeatherDataPropertyKey.country)
        aCoder.encode(temperature, forKey: WeatherDataPropertyKey.temperature)
        aCoder.encode(humidity, forKey: WeatherDataPropertyKey.humidity)
        aCoder.encode(pressure, forKey: WeatherDataPropertyKey.pressure)
        aCoder.encode(windSpeed, forKey: WeatherDataPropertyKey.windSpeed)
    }
    
}

struct WeatherDataPropertyKey {
    static let locationName = "locationName"
    static let country = "country"
    static let temperature = "temperature"
    static let humidity = "humidity"
    static let pressure = "pressure"
    static let windSpeed = "windSpeed"
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
            humidity: Int64(jsonData.main.humidity),
            pressure: Int64(jsonData.main.humidity),
            windSpeed: Float(jsonData.main.pressure)
        )
    }
    
    private func handleData(data: Data?) {
        do {
            let jsonData = try self.jsonDecoder.decode(JSONWeatherData.self, from: data!)
            let weatherData = self.makeWeatherDataCurrent(jsonData: jsonData)
            
            // ViewController methods need to be called on the main thread async
            DispatchQueue.main.async {
                self.viewController.setCurrentWeather(weatherData: weatherData)
            }
        }
        catch {
            self.handleError(error: error)
        }
    }
    
    private func handleError(error: Error?) {
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
