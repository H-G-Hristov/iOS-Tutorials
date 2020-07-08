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
    
    var localWeatherImage: UIImage?
    var localWeatherAttributedString: NSAttributedString?
    
    // MARK: Initializers and delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let receivedImage = localWeatherImage {
            imageViewLocalWeather.image = receivedImage
        }
        if let receivedAttributedText = localWeatherAttributedString {
            labelLocalWeather.attributedText = receivedAttributedText
        }
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
