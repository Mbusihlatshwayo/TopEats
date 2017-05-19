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
        tableView.separatorColor = UIColor.green
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cuisineCell") as? CuisineTableViewCell {
            //cell?.textLabel?.text = cuisinearray[indexPath.row]
            //return cell!
            cell.cuisineImage.image = UIImage(named: "\(indexPath.row+1)")
            print("Imagename: \(indexPath.row+1)")
            cell.cuisineLabel.text = cuisinearray[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(cuisinearray.count)")
        return cuisinearray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
