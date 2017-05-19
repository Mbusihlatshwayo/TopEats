//
//  CommunityViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cuisinearray = ["American", "Cajun", "Caribbean", "Chinese", "French", "German", "Greek", "Indian", "Italian", "Japanese", "Korean", "Lebanese", "Mediterranean", "Mexican", "Moroccan", "Soul", "Spanish", "Thai", "Turkish", "Vietnamese"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cuisineCell")
        cell?.textLabel?.text = cuisinearray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisinearray.count
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
