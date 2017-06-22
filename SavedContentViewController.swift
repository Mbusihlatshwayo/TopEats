//
//  SavedContentViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/18/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

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
//        if places.count == 0 {
//            tableView.isHidden = true
//        } else {
//            tableView.isHidden = false
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
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
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT: \(places.count)")
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? NewsTableViewCell {
            newsCell.configWithCoreData(place: places[indexPath.row])
            newsCell.saveButton.addTarget(self, action:#selector(saveClicked(sender:)), for: .touchUpInside)
            print("already setting up cells")
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
            print("Fetching Failed")
        }
        tableView.reloadData()
    }

    
    func getData() {
        do {
            places = try context.fetch(CDPlace.fetchRequest())
            print("PLACES COUNT = \(places.count)")
            tableView.reloadData()
        } catch {
            print("Fetching Failed")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
