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
    
    // function to configure custom table view cell
    func configCell(place: Place) {
        // only animate on initial load
        if place.shouldAnimate {
            // hide image and label before image is loaded
            headlineImage.alpha = 0
            headlineLabel.alpha = 0
            saveButton.alpha = 0
            headlineLabel.text = place.name
            print("NAME")
            // set image asynchronously
            headlineImage.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: .continueInBackground) { (_, _, _, _ ) in
                // image download complete fade in image
//                print("COMPLETED SD SET IMAGE")
                UIView.animate(withDuration: 1.5, animations: {
                    self.headlineImage.alpha = 1
                    self.headlineLabel.alpha = 1
                    self.saveButton.alpha = 1
                    place.shouldAnimate = false
                })
            }
        } else {
            headlineLabel.text = place.name
            headlineImage.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: .continueInBackground)
        }
        
    }
    
    func configWithCoreData(place: CDPlace) {
        headlineLabel.text = place.name
        headlineImage.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photoRef!)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: .continueInBackground)
        print("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(place.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0")
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("button pressed")
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
