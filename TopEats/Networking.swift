//
//  Networking.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingFunctionality {
    
    class func downloadPlaces(completion: @escaping ([Place]) -> Void) {
        // download google places restaurants
        let PLACE_REQUEST_URL = URL(string: PLACES_URL)
        print("PLACES URL: \(PLACE_REQUEST_URL)")
        Alamofire.request(PLACE_REQUEST_URL!).responseJSON(completionHandler: {response -> Void in
            switch response.result {
                
                // download successful
                case .success(let value):
//                    print("SUCCESS VALUE: \(value)")
                    var places = [Place]()
                    var placeInstance: Place!
                    if let resultDict = response.result.value as? Dictionary<String, AnyObject> {
                        // need to change this to handle json with swiftyjson safely
                        print("ABLE TO PARSE RESULT VALUE INTO DICTIONARY")
                        if let results = resultDict["results"] as? [Dictionary<String, AnyObject>] {
                            print("ABLE TO PARSE INTO ARRAY OF DICTS")
                            for object in results {
                                var place_name: String!
                                var place_open_or_not: Bool?
                                var place_photo_ref: String?
                                var place_rating: Int?
                                var place_address: String!
                                if let name = object["name"] as? String {
                                    print("NAME: \(name)")
                                    place_name = name
                                }
                                if let open = object["opening_hours"]?["open_now"] as? Bool {
                                    print("OPEN: \(open)")
                                    place_open_or_not = open
                                } else {
                                    print("UNABLE TO GET HOURS")
                                    place_open_or_not = nil
                                }
                                if let photosArr = object["photos"] as? [Dictionary<String, AnyObject>] {
                                    print("LOCATION HAS PHOTO")
                                    if let photoRef = photosArr[0]["photo_reference"] as? String {
                                        print("PHOTO_REF: \(photoRef)")
                                        place_photo_ref = photoRef
                                    }
                                } else {
                                    print("UNABLE TO GET PHOTO REF")
                                    place_photo_ref = nil
                                }
                                if let rating = object["rating"] as? Int {
                                    print("RATING: \(rating)")
                                    place_rating = rating
                                } else {
                                    print("UNABLE TO GET RATING")
                                    place_rating = nil
                                }
                                if let address = object["vicinity"] as? String {
                                    print("ADDRESS: \(address)")
                                    place_address = address
                                }
                                placeInstance = Place(name: place_name, open: place_open_or_not, photoRef: place_photo_ref, rating: place_rating, address: place_address)
                                places.append(placeInstance)
                                }
                        }
                    }
                    completion(places)
                    
                case .failure(let error):
                    print("ALAMOFIRE ERROR: \(error)")
                    completion([])
            }
        })
    }
    
    
}
