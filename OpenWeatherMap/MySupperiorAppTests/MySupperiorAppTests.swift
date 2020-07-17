//
//  MySupperiorAppTests.swift
//  MySupperiorAppTests
//
//  Created by Hristo Hristov on 12.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import XCTest
@testable import MySupperiorApp

class MySupperiorAppTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: SavedWeatherData Class Tests
    
    // Confirm that the SavedWeatherData initializer returns a Meal object when passed valid parameters.
    func testSavedWeatherDataInitializationSucceeds() {
        let image: UIImage? = nil
        let weather = String("Weather")
        let weatherData = WeatherData(
            locationName: "London",
            country: "uk",
            temperature: 99,
            humidity: 99,
            pressure: 99,
            windSpeed: 99)
        
        let savedWeatherData = SavedWeatherData.init(image: image, weather: weather, weatherData: weatherData)
        
        XCTAssertNotNil(savedWeatherData)
    }
    
    // Confirm that the SavedWeatherData initialier returns nil when passed a negative rating or an empty name.
    func testSavedWeatherDataInitializationFails() {
        let image: UIImage? = nil
        let weather = String()
        let weatherData = WeatherData(
            locationName: "London",
            country: "uk",
            temperature: 99,
            humidity: 99,
            pressure: 99,
            windSpeed: 99)
        
        // Test for empty weater string
        let savedWeatherData_EmptyString = SavedWeatherData.init(image: image, weather: weather, weatherData: weatherData)
        
        XCTAssertNil(savedWeatherData_EmptyString)
    }
    
}
