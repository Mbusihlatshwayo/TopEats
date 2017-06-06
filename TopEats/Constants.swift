//
//  Constants.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation

let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)&radius=16093&types=restaurant&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"

typealias DownloadComplete = () -> ();
