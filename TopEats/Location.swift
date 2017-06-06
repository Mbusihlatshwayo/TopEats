//
//  Location.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
