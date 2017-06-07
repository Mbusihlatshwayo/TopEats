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
    
    var places = [Place]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupDummyData()
        if places.count == 0 {
            tableView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared")
    }
    func setupDummyData() {
        /* create objects for table view dummy data */
//        let newsObject = News(image: "restaurant1", headText: "A one", articleText: "It is a great place try it")
//        let newsObject1 = News(image: "restaurant2", headText: "A twooo", articleText: "Really listen and give it a shot")
//        let newsObject2 = News(image: "restaurant3", headText: "Threeee", articleText: "We have nice food try it sometime")
//        newsArray.append(newsObject)
//        newsArray.append(newsObject1)
//        newsArray.append(newsObject2)
//        newsArray.append(newsObject1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            print("already setting up cells")
            return newsCell
        }
        else {
            return NewsTableViewCell()
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
