//
//  Helpers.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 16.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    func showToast(message: String, seconds: Double = 2.0) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
}
