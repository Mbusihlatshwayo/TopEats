//
//  FeaturedContentViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/17/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import Alamofire
import NVActivityIndicatorView

class FeaturedContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,CLLocationManagerDelegate  {

    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredScrollView: UIScrollView!
    
    //MARK: - PROPERTIES
    var newsObject: News!
    var newsObject1: News!
    var newsObject2: News!
    var newsArray = [News]()
    var currentPage: Int = 0
    var currentX: CGFloat!
    var previousX: CGFloat!
    var newX: CGFloat!
    var myTimer: Timer!
    var placesClient: GMSPlacesClient!
    let locationMgr = CLLocationManager()
    var currentLocation: CLLocation!
    var places = [Place]()
    var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - VIEW METHODSF
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewContent()
        placesClient = GMSPlacesClient.shared()
        requestLocServices()
        downloadPlaces()
//        activityIndicator.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - LOCATION METHODS
    func requestLocServices() {
        // 1
        let status  = CLLocationManager.authorizationStatus()
        
        // 2
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 4
        locationMgr.delegate = self
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest // want coordinates to be very accurate
        locationMgr.requestWhenInUseAuthorization() // only want location when looking for weather
        locationMgr.startMonitoringSignificantLocationChanges()
        locationMgr.startUpdatingLocation()
        // get location for shared instance
        currentLocation = locationMgr.location
        Location.sharedInstance.latitude = currentLocation.coordinate.latitude
        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // authorized location status when app is in use; update current location
            //            locationManager.startUpdatingLocation()
            print("LOCATION SUCCESS")
            currentLocation = locationMgr.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            print("INSTANCE LAT = \(Location.sharedInstance.latitude)")
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print("INSTANCE LON = \(Location.sharedInstance.longitude)")
            print("location : \(Location.sharedInstance.latitude!) \(Location.sharedInstance.longitude!)")
            // implement download function for data here...
        }
        // implement logic for other status values if needed...
    }
    
    
    func downloadPlaces() {
        print("INSIDE DOWNLOAD FUNC")
        tableView.isHidden = true
//        let centerFrame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 40, height: 40)
        let centerFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = NVActivityIndicatorView(frame: centerFrame, type: .ballPulseSync, color: UIColor.green)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        NetworkingFunctionality.downloadPlaces(completion: { [weak self] data in
            self?.places = data
            self?.tableView.reloadData()
//            self?.tableview.isHidden = false
            self?.tableView.isHidden = false
            self?.activityIndicator?.stopAnimating()
        })
        
    }
    
    func initializeViewContent() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.green
        featuredScrollView.isPagingEnabled = true
        featuredScrollView.showsVerticalScrollIndicator = false
        featuredScrollView.delegate = self
        /* ---------------------------------------- */
        myTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        setupDummyData()
        loadFeaturedItems() // send it off to load all data into featured view
    }
    
    func setupDummyData() {
        /* create objects for table view dummy data */
        newsObject = News(image: "restaurant1", headText: "Dummy Headline", articleText: "It is a great place try it")
        newsObject1 = News(image: "restaurant2", headText: "Anotha one", articleText: "Really listen and give it a shot")
        newsObject2 = News(image: "restaurant3", headText: "Here", articleText: "We have nice food try it sometime")
        newsArray.append(newsObject)
        newsArray.append(newsObject1)
        newsArray.append(newsObject2)
        newsArray.append(newsObject1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myTimer.invalidate()
    }
    
    // MARK: - FEATURED SCROLL VIEW METHODS
    func runTimedCode() {
//        print("TIMER FIRED go to page \(currentPage)")
        let itemCount = newsArray.count // how many items are in the news reel
        if currentPage < itemCount {
            newX = CGFloat(currentPage) * self.view.frame.width // calculate next page position
            featuredScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
            currentPage += 1
        } else {
            // end of items
            currentPage = 0
            let newX = CGFloat(currentPage) * self.view.frame.width // calculate next page position
            featuredScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
    }
    
    func loadFeaturedItems() {
        
        // set up featured content for scroll view
        for (index, featuredNews) in newsArray.enumerated() {
            if let featuredNewsView = Bundle.main.loadNibNamed("FeaturedContent", owner: self, options: nil)?.first as? FeaturedContentView {
                featuredNewsView.featuredImage.image = UIImage(named: featuredNews.headlineImage)
                featuredNewsView.featuredLabel.text = featuredNews.headlineText
                
                featuredScrollView.addSubview(featuredNewsView)
                featuredNewsView.frame.size.width = self.view.bounds.width
                featuredNewsView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                featuredScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(newsArray.count), height: 225)
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // if the user dragged the carousel update the current page number
        if scrollView == featuredScrollView {
            currentX = featuredScrollView.contentOffset.x
            if currentX < newX {
                currentPage -= 1
            } else if currentX > newX {
                currentPage += 1
            }
        }
    }
    
    // MARK: - TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showPlaceDetail", sender: place)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? NewsTableViewCell {
            newsCell.configCell(place: places[indexPath.row])
//            places[indexPath.row].shouldAnimate = false // animate the image only once on initial load
            return newsCell
        }
        else {
            return NewsTableViewCell()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if let place = sender as? Place {
            let detailPlaceVC = segue.destination as! DetailPlaceViewController
            detailPlaceVC.place = place
        }
    }
    

}
