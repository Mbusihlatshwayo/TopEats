//
//  Constants.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import UIKit

let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)&radius=805&types=restaurant&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"
let topEatsGreen = UIColor(red:0.00, green:0.60, blue:0.33, alpha:1.0)
