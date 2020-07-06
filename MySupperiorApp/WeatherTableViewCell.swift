//
//  WeatherTableViewCell.swift
//  MySupperiorApp
//
//  Created by Hristo Hristov on 1.07.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import UIKit

class TableViewCellCurrentWeather: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var labelWeather: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
