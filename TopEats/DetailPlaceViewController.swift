//
//  DetailPlaceViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/8/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import SwiftyStarRatingView
import SDWebImage

class DetailPlaceViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var addresText: UITextView!
    
    // MARK: - PROPERTIES
    var place: Place?
    
    // MARK: - IBACTIONS
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateImageView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("SCROLLED")
    }
    func animateImageView() {
        // set image asynchronously with animation
        placeImageView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(self.place!.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: .continueInBackground) { (_, _, _, _ ) in
            // image download complete fade in image
//            print("COMPLETED SD SET IMAGE")
            UIView.animate(withDuration: 1, animations: {
                self.placeImageView.alpha = 1
                print("ANIMATED HEREEEEE")
            })
        }
    }

    func setUpView() {
        placeImageView.alpha = 0
        // init view title label with location name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = place!.name
        // init star rating view with location rating value
        starRatingView.value = CGFloat(place!.rating)
        let topEatsGreen = UIColor(red:0.00, green:0.60, blue:0.33, alpha:1.0)
        starRatingView.tintColor = topEatsGreen
        // init address label text with location address 
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.text = place!.address
        addresText.text = place!.address
        // init hours label with location open status
        hoursLabel.text = place!.open
    }
}
