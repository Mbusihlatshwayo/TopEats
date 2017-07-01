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
import GoogleMaps
import Alamofire

class DetailPlaceViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var attributionsLabel: UILabel!
    @IBOutlet weak var googleAttributionImage: UIImageView!
    
    // MARK: - PROPERTIES
    var place: Place?
    let locationMgr = CLLocationManager()
    
    // MARK: - IBACTIONS
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didPressDirectionsButton(_ sender: Any) {
        
            let regionDistance:CLLocationDistance = 100
            let coordinates = place?.location.coordinate
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates!, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates!, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = place?.name
            mapItem.openInMaps(launchOptions: options)
        
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
    }
    
    func googleMapSetup() {
        self.mapView.isMyLocationEnabled = true;
        self.mapView.settings.compassButton = true;
        self.mapView.settings.myLocationButton = true;
        self.mapView.delegate = self;
        let camera = GMSCameraPosition.camera(withLatitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude, zoom: 14.0)
        mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: (place?.location.coordinate.latitude)!, longitude: (place?.location.coordinate.longitude)!)
        let marker = GMSMarker(position: position)
        marker.title = place?.name
        marker.map = mapView
        mapView.settings.scrollGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        
    }
    
    // MARK: - ANIMATIONS
    func animateImageView() {
        // set image asynchronously with animation
        placeImageView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(self.place!.photoRef)&key=AIzaSyACJKXW98TFV6nb0YHqksfJJ3_Y8gkDib0"), placeholderImage: UIImage(named: "restaurant"), options: .continueInBackground) { (_, _, _, _ ) in
            // image download complete fade in image
            UIView.animate(withDuration: 1, animations: {
                self.placeImageView.alpha = 1
                self.googleAttributionImage.alpha = 1
            })
        }
    }

    func setUpView() {
        placeImageView.alpha = 0
        googleAttributionImage.alpha = 0
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
        // init attributes label with html
        attributionsLabel.adjustsFontSizeToFitWidth = true
        attributionsLabel.text = place!.attributes
        // init map data and route
        googleMapSetup()
        drawRoute()
    }

    // MARK: - MAP VIEW METHODS
    let regionRadius: CLLocationDistance = 700

    func drawRoute() {
        let origin = "\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)"
        let destination = "\(String(describing: place!.location.coordinate.latitude)),\(String(describing: place!.location.coordinate.longitude))"
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        Alamofire.request(directionsURL).responseJSON { response in
            switch response.result {
                
            // download successful
            case .success:
                if let resultDict = response.result.value as? Dictionary<String, AnyObject> {
                    if let routes = resultDict["routes"] as? [Dictionary<String, AnyObject>] {
                        for route in routes {
                            let overviewPolyline = route["overview_polyline"] as? Dictionary<String, AnyObject>
                            let points = overviewPolyline?["points"] as? String
                            let path = GMSPath.init(fromEncodedPath: points!)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 5
                            polyline.strokeColor = topEatsGreen
                            polyline.map = self.mapView
                        }
                    }

                }
            case .failure:
                break
            }

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
