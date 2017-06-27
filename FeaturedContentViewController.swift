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
import CoreData

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
    var shouldReloadData = true
    var updateLocationCount = 0
    private let refreshControl = UIRefreshControl()
    
    // MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        places.removeAll()
        self.navigationController?.navigationBar.isHidden = true
        locationMgr.delegate = self
        initializeViewContent()
        requestLocServices()
        placesClient = GMSPlacesClient.shared()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - LOCATION METHODS
    
    func isLocationEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    
    func requestLocServices() {
        // get the status of the location manager
        let status  = CLLocationManager.authorizationStatus()
        
        // if we havent received the status request location services
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        // tell user to activate location services
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        // set up location manager to get location
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.startMonitoringSignificantLocationChanges()
        locationMgr.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // authorized location status when app is in use; update current location
            locationMgr.startUpdatingLocation()
        } else {
            if !isLocationEnabled() {
                showAlert(alertTitle: "Sorry", alertMessage: "Please enable location services to see local restaurants.")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // workaround for simulator delaying location manager coordinates. Come back and fix.
        updateLocationCount = updateLocationCount + 1
        currentLocation = manager.location
        // set the location
        Location.sharedInstance.latitude = currentLocation.coordinate.latitude
        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        print("Location: \(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)")
        if shouldReloadData && updateLocationCount == 3 {
            // we only load the intial data once
            downloadPlaces()
            shouldReloadData = false // change the flag to not update data
        }
        
    }
    
    func downloadPlaces() {
        refreshControl.isUserInteractionEnabled = false
        let centerFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = NVActivityIndicatorView(frame: centerFrame, type: .ballPulseSync, color: topEatsGreen)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        NetworkingFunctionality.downloadPlaces(completion: { [weak self] data in
            self?.refreshControl.isUserInteractionEnabled = true
            self?.places = data
            self?.tableView.reloadData()
            self?.activityIndicator?.stopAnimating()
            self?.refreshControl.endRefreshing()
        })
        
    }
    
    func initializeViewContent() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.green
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(downloadPlaces), for: .valueChanged)
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
            newsCell.saveButton.tag = indexPath.row // get the index of the place for the saving action
            newsCell.saveButton.addTarget(self, action:#selector(saveClicked(sender:)), for: .touchUpInside)
            newsCell.saveButton.setImage(UIImage(named: "favoriteditem")?.withRenderingMode(.alwaysOriginal), for: .normal)
            newsCell.saveButton.setImage(UIImage(named: "favoriteditemenabled")?.withRenderingMode(.alwaysOriginal), for: [.selected])
            if isItemSaved(place: places[indexPath.row]) {
                newsCell.saveButton.isSelected = true
            } else {
                newsCell.saveButton.isSelected = false
            }
            return newsCell
        }
        else {
            return NewsTableViewCell()
        }
    }
    
    func isItemSaved(place: Place) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            var savedPlaces: [CDPlace]?
            savedPlaces = try context.fetch(CDPlace.fetchRequest())
            for object in savedPlaces! {
                if place.id == object.id {
                    return true
                }
            }
        } catch {
            return false
        }
        return false
    }
    
    func saveClicked(sender:UIButton) {
        // the index of the calling place
        let buttonRow = sender.tag
        let nc = NotificationCenter.default
        
        if (sender.isSelected == false) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let place = CDPlace(context: context) // Link place to Context
            place.name = places[buttonRow].name
            place.address = places[buttonRow].address
            place.latitude = places[buttonRow].location.coordinate.latitude
            place.longitude = places[buttonRow].location.coordinate.longitude
            place.open = places[buttonRow].open
            place.photoRef = places[buttonRow].photoRef
            place.rating = Double(places[buttonRow].rating)
            place.id = places[buttonRow].id
            place.attributes = places[buttonRow].attributes
            // Save the data to coredata
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            // post notification to notify of new saved data
            nc.post(name: Notification.Name("coreDataChanged"), object: nil)

        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                let idToDelete = places[buttonRow].id
                var savedPlaces: [CDPlace]?
                savedPlaces = try context.fetch(CDPlace.fetchRequest())
                for obj in savedPlaces! {
                    if obj.id == idToDelete {
                        context.delete(obj)
                    }
                }
            } catch {
            }
            nc.post(name: Notification.Name("deletedCoreData"), object: nil)
            
        }
        sender.isSelected = !sender.isSelected
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
