//
//  SavedContentViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/18/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import MapKit

class SavedContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var places = [CDPlace]()
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        notificationCenter.addObserver(self, selector: #selector(addToSavedPlaces), name: Notification.Name("coreDataChanged"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(addToSavedPlaces), name: Notification.Name("deletedCoreData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        tableView.reloadData()
    }
    
    func addToSavedPlaces() {
        getData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showSaved", sender: place)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? NewsTableViewCell {
            newsCell.configWithCoreData(place: places[indexPath.row])
            newsCell.saveButton.tag = indexPath.row // get the index of the place for the saving action
            newsCell.saveButton.addTarget(self, action:#selector(saveClicked(sender:)), for: .touchUpInside)
            return newsCell
        }
        else {
            return NewsTableViewCell()
        }
        
    }
    
    func saveClicked(sender:UIButton) {
        // the index of the calling place
        let buttonRow = sender.tag
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let place = places[buttonRow]
        context.delete(place)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do {
            places = try context.fetch(CDPlace.fetchRequest())
        } catch {
        }
        tableView.reloadData()
    }

    
    func getData() {
        do {
            places = try context.fetch(CDPlace.fetchRequest())
            tableView.reloadData()
        } catch {
        }
    }
    
    func convertToPlace(place: CDPlace) -> Place {
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        let placeObj = Place(name: place.name, open: nil, photoRef: place.photoRef, rating: Float(place.rating), address: place.address, animated: false, location: location, id: place.id!, attributes: place.attributes)
        return placeObj
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let savedPlace = convertToPlace(place: sender as! CDPlace)
        let detailPlaceVC = segue.destination as! DetailPlaceViewController
        detailPlaceVC.place = savedPlace
    }
 

}
