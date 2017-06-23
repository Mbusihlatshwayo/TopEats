//
//  Place.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import MapKit

class Place {
    
    private var _name: String!
    private var _open: Bool!
    private var _photoRef: String!
    private var _rating: Float!
    private var _address: String!
    private var _shouldAnimate: Bool!
    private var _location: CLLocation!
    private var _id: String!
    
    var id: String {
        return _id
    }
    
    var location: CLLocation {
        return _location
    }
    
    var shouldAnimate: Bool {
        set {
            _shouldAnimate = newValue
        }
        get {
            return _shouldAnimate
        }
    }
    
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
    
    var rating: Float {
        return _rating
    }
    
    var address: String {
        if _address != nil {
            return _address
        } else {
            return "No address available"
        }
    }
    
    init(name: String!, open: Bool?, photoRef: String?, rating: Float?, address: String!, animated: Bool!, location: CLLocation, id: String) {
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
            self._rating = 0
        }
        
        self._shouldAnimate = animated
        // we always have an address
        self._address = address
        self._location = location
        self._id = id
    }
    
}
