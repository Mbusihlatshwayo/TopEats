//
//  Networking.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/5/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

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
                                var place_rating: Float?
                                var place_address: String!
                                var place_location: CLLocation!
                                var place_id: String!
                                
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
                                if let rating = object["rating"] as? Float {
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
                                if let geometry = object["geometry"] as? Dictionary<String, AnyObject>, let location = geometry["location"] as? Dictionary<String, AnyObject>, let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                                    place_location = CLLocation(latitude: latitude, longitude: longitude)
                                }
                                
                                if let id = object["id"] as? String {
                                    place_id = id
                                }
                                
                                placeInstance = Place(name: place_name, open: place_open_or_not, photoRef: place_photo_ref, rating: place_rating, address: place_address, animated: true, location: place_location, id: place_id)
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
    
    class func searchPlaces(searchKeyword: String,completion: @escaping ([Place]) -> Void) {
        // download google places restaurants
        let BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)&radius=805&type=restaurant&name=\(searchKeyword)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"
        let PLACE_REQUEST_URL = URL(string: BASE_URL)
        print("PLACES URL: \(String(describing: PLACE_REQUEST_URL))")
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
                            var place_rating: Float?
                            var place_address: String!
                            var place_location: CLLocation!
                            var place_id: String!
                            
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
                            if let rating = object["rating"] as? Float {
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
                            if let geometry = object["geometry"] as? Dictionary<String, AnyObject>, let location = geometry["location"] as? Dictionary<String, AnyObject>, let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                                place_location = CLLocation(latitude: latitude, longitude: longitude)
                            }
                            
                            if let id = object["id"] as? String {
                                place_id = id
                            }
                            
                            placeInstance = Place(name: place_name, open: place_open_or_not, photoRef: place_photo_ref, rating: place_rating, address: place_address, animated: true, location: place_location, id: place_id)
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
