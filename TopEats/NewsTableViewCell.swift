//
//  NewsTableViewCell.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/15/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var headlineImage: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    func configCell(news: News) {
        // configure cell here
        headlineImage.image = UIImage(named: news.headlineImage)
        headlineLabel.text = news.headlineText
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
