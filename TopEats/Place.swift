//
//  Place.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation

class Place {
    
    var _name: String!
    var _open: Bool!
    var _photoRef: String! // sunny, cloudy, overcast...
    var _rating: Int!
    var _address: String!
    
    init(name: String!, open: Bool?, photoRef: String?, rating: Int?, address: String!) {
        // we always have a name
        self._name = name
        
        if open != nil {
            self._open = open
        } else {
            // handle what to do if the store has no hours
        }
        
        if photoRef != nil {
            self._photoRef = photoRef
        } else {
            // handle empty photo
        }
        
        if rating != nil {
            self._rating = rating
        } else {
            // handle empty rating
        }
        
        // we always have an address
        self._address = address
    }
    
}
