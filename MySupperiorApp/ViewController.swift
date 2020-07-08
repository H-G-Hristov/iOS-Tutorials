//
//  ViewController.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 12.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation
import UIKit

import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var textFieldLocationName: UITextField!
    @IBOutlet weak var buttonGetForecast: UIButton!
    @IBOutlet weak var buttonGetWeather: UIButton!
    @IBOutlet weak var imageViewCurrentWeather: UIImageView!
    @IBOutlet weak var labelCurrentWeather: UILabel!
    @IBOutlet weak var stackViewCurrentWeather: UIStackView!
    @IBOutlet weak var tableViewCurrentWeather: UITableView!
    @IBOutlet var tapGestureRecognizerCurrentWeather: UITapGestureRecognizer!
    
    // MARK: Constants
    
    private let defaultCityName = "London"
    private let defaultCountryCode = "uk"
    
    // MARK: Variables
    
    private var defaultTextFieldBackgroundColor: UIColor? = nil
    private var weatherDataOnlineManager: WeatherDataOnlineManager? = nil
    
    private var currentSavedWeatherData: SavedWeatherData? = nil
    
    // MARK: Initializers and delegates
    
    required init?(coder: NSCoder?) {
        super.init(coder: coder!)
        
        weatherDataOnlineManager = WeatherDataOnlineManager(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // TextField initialization
        textFieldLocationName.placeholder = "Enter location name, (e.g. \(defaultCityName),\(defaultCountryCode)"
        // Handle the text field’s user input through delegate callbacks.
        textFieldLocationName.delegate = self
        
        defaultTextFieldBackgroundColor = textFieldLocationName.backgroundColor
        
        // Button initialization
        setButtonDisabled(button: buttonGetForecast)
        setButtonDisabled(button: buttonGetWeather)
        
        // Current Weather view initialization
        labelCurrentWeather.text = nil
        tapGestureRecognizerCurrentWeather.isEnabled = false
        
        // TableView initialization
        tableViewCurrentWeather.delegate = self
        tableViewCurrentWeather.dataSource = self
    }
    
    // MARK: Actions
    
    @IBAction func touchedButtonGetWeather(_ sender: Any) {
        guard let locationName = textFieldLocationName.text, !locationName.isEmpty else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            
            return
        }
        
        let location = locationName.split(separator: ",")
        
        var cityName: String? = nil
        var countryCode: String? = nil
        
        switch location.count {
        case 1:
            cityName = String(location[0])
        case 2:
            cityName = String(location[0])
            countryCode = String(location[1])
        default:
            cityName = defaultCityName
            countryCode = defaultCountryCode
        }
        
        guard nil != cityName && nil != countryCode else {
            showToast(
                message:
                """
                Invalid location!\n \
                Please enter a valid location\n \
                (e.g. \(String(describing: cityName)),\(String(describing: countryCode))
                """,
                seconds: 5.0)
            
            return
        }
        
        cityName = cityName?.trimmingCharacters(in: .whitespacesAndNewlines)
        countryCode = countryCode?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        weatherDataOnlineManager?.requestData(locationName: cityName!, countryCode: countryCode!)
        
        textFieldLocationName.text = nil
        setButtonDisabled(button: buttonGetForecast)
        setButtonDisabled(button: buttonGetWeather)
    }
    
    @IBAction func gestureRecognizerTap(_ sender: Any) {
    }
    
    @IBAction func unwindToWorldWeatherData(sender: UIStoryboardSegue) {
    }
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let viewControllerLocalWeather = segue.destination as! ViewControllerLocalWeather
        
        if let image = imageViewCurrentWeather.image {
            viewControllerLocalWeather.localWeatherImage = image
        }
        
        if let attribitedText = labelCurrentWeather.attributedText {
            viewControllerLocalWeather.localWeatherAttributedString = attribitedText
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if text.isEmpty{
            setButtonDisabled(button: buttonGetForecast)
            setButtonDisabled(button: buttonGetWeather)
            
        } else {
            
            setButtonEnabled(button: buttonGetForecast)
            setButtonEnabled(button: buttonGetWeather)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    // MARK: Methods
    
    func changeViewColor(weatherType : WeatherType) {
        let weatherColor = makeWeatherColor(weatherType: weatherType)
        labelCurrentWeather.backgroundColor = weatherColor
        imageViewCurrentWeather.backgroundColor = weatherColor
    }
    
    func makeWeatherColor(weatherType: WeatherType) -> UIColor {
        let colorBias = {
            () -> (red: UInt32, green: UInt32, blue: UInt32) in
            switch(weatherType) {
            case WeatherType.Cloudy:
                return ( red: 200, green: 200, blue: 200)
            case WeatherType.Rainy:
                return ( red: 25, green: 50, blue: 245)
            case WeatherType.Stormy:
                return ( red: 15, green: 15, blue: 255)
            case WeatherType.Sunny:
                return ( red: 245, green: 245, blue: 15)
            }
        }()
        
        return makeColor(redBias: colorBias.red, greenBias: colorBias.green, blueBias: colorBias.blue)
    }
    
    func makeColor(redBias: UInt32, greenBias: UInt32, blueBias: UInt32) -> UIColor {
        let red = CGFloat(redBias + arc4random_uniform(256 - redBias))
        let green = CGFloat(greenBias + arc4random_uniform(256 - greenBias))
        let blue = CGFloat(blueBias + arc4random_uniform(256 - blueBias))
        
        return UIColor(
            red: (red / 255.0),
            green: (green / 255.0),
            blue: (blue / 255.0),
            alpha: 1.0)
    }
    
    func setButtonEnabled(button: UIButton) {
        button.isEnabled = true
        button.alpha = 1
    }
    
    func setButtonDisabled(button:UIButton) {
        button.isEnabled = false
        button.alpha = 0.2
    }
    
    func setCurrentWeather(weatherData: WeatherData) {
        currentSavedWeatherData = SavedWeatherData(weatherData: weatherData)
        
        displayCurrentWeather(savedWeatherData: currentSavedWeatherData!)
    }
    
    func displayCurrentWeather(savedWeatherData: SavedWeatherData) {
        if let attributedText = savedWeatherData.weatherAttributedText {
            imageViewCurrentWeather.image = UIImage(named: savedWeatherData.imageName);
            labelCurrentWeather.attributedText = attributedText
            
            changeViewColor(weatherType: savedWeatherData.weatherType)
        }
        
        tapGestureRecognizerCurrentWeather.isEnabled = true
    }
    
    func clearCurrentWeather() {
        // TODO: changeViewColor(weatherType: weatherType)
        
        imageViewCurrentWeather.image = nil
        labelCurrentWeather.text = nil
    }
    
    func saveCurrentWeatherToTableView() {
        os_log("Save current weather to TableView")
        //showToast(message: "Save current weather to TableView", seconds: 2)
    }
    
}

extension ViewController: UITableViewDataSource {
        // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellCurrentWeather", for: indexPath)
        
        
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
}
