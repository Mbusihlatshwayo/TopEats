//
//  CuisineTableViewCell.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class CuisineTableViewCell: UITableViewCell {

    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var cuisineImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
