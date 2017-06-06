//
//  Place.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation

class Place {
    
    private var _name: String!
    private var _open: Bool!
    private var _photoRef: String! // sunny, cloudy, overcast...
    private var _rating: Int!
    private var _address: String!
    
    var name: String {
        if _name != nil {
            return _name
        } else {
            _name = "No name available"
            return _name
        }
    }
    
    var open: String {
        if _open != nil {
            switch _open {
            case false:
                return "Closed"
            default:
                return "Open"
            }
        } else {
            return "Hours unavailable"
        }
    }
    
    var photoRef: String {
        if _photoRef != nil {
            return _photoRef
        } else {
            return "CnRtAAAATLZNl354RwP_9UKbQ_5Psy40texXePv4oAlgP4qNEkdIrkyse7rPXYGd9D_Uj1rVsQdWT4oRz4QrYAJNpFX7rzqqMlZw2h2E2y5IKMUZ7ouD_SlcHxYq1yL4KbKUv3qtWgTK0A6QbGh87GB3sscrHRIQiG2RrmU_jF4tENr9wGS_YxoUSSDrYjWmrNfeEHSGSc3FyhNLlBU"
        }
    }
    
    var rating: String {
        switch _rating {
        case 0:
            return "0"
        case 1:
            return "1"
        case 2:
            return "2"
        case 3:
            return "3"
        case 4:
            return "4"
        case 5:
            return "5"
        default:
            return "No ratings yet"
        }
    }
    
    var address: String {
        if _address != nil {
            return _address
        } else {
            return "No address available"
        }
    }
    
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
