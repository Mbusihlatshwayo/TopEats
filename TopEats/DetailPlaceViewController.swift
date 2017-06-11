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
import MapKit

class DetailPlaceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - PROPERTIES
    var place: Place?
    let locationMgr = CLLocationManager()
    
    // MARK: - IBACTIONS
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setUpView()
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.startUpdatingLocation()
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
        starRatingView.tintColor = topEatsGreen
        // init address label text with location address
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.text = place!.address
        // init hours label with location open status
        hoursLabel.text = place!.open
        setUpMap()
    }
    
    func setUpMap() {
        mapView.delegate = self
        centerMapOnLocation(location: place!.location)
        let annotation = MKPointAnnotation()
        annotation.coordinate = place!.location.coordinate
        annotation.title = place!.name
        mapView.addAnnotation(annotation)
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = true
        drawRoute()
    }
    
    // MARK: - MAP VIEW METHODS
    let regionRadius: CLLocationDistance = 700
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    func drawRoute() {
        // get the user and destination location coordinates
        let userLocation = CLLocationCoordinate2D(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        let destinationLocation = CLLocationCoordinate2D(latitude: place!.location.coordinate.latitude, longitude: place!.location.coordinate.longitude)
        
        // create placemarks from the locations
        let userPlacemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // get map items to handle routing
        let sourceMapItem = MKMapItem(placemark: userPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // compute the route to the destination
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the directions
        let directions = MKDirections(request: directionRequest)
        

        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("DIRECTIONS ERROR: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = topEatsGreen
        renderer.lineWidth = 6.0
        
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

}
