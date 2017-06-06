//
//  NewsTableViewCell.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/15/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    func configCell(place: Place) {
        // configure cell here
        headlineImage.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: [.continueInBackground, .progressiveDownload])
        headlineLabel.text = place.name
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveButton.setImage(UIImage(named: "favoriteditemenabled"), for: UIControlState.selected)
        print("change image")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
