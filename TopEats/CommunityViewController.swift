//
//  CommunityViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // PROPERTIES
    let cuisinearray = ["American", "Cajun", "Caribbean", "Chinese", "French", "German", "Greek", "Indian", "Italian", "Japanese", "Korean", "Lebanese", "Mediterranean", "Mexican", "Moroccan", "Soul", "Spanish", "Thai", "Turkish", "Vietnamese"]
    private var communitySectionsRefHandle: DatabaseHandle?
    private lazy var communitySectionsRef: DatabaseReference = Database.database().reference().child("Sections")
    var sections: [Section] = []
    
    var senderDisplayName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.green
     
        setUpData()
    }
    
    func setUpData() {
        // need to set up cuisine array with objects of type section in order to push messages into database
//        for obj in cuisinearray {
//            let name = obj
        let newSectionRef = communitySectionsRef.childByAutoId()
//            let sectionItem = [
//                "name": name
//            ]
//            newSectionRef.setValue(sectionItem)
        communitySectionsRef.observe(.value, with: { (DataSnapshot) in
            var index = 0
            for child in DataSnapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                
                self.sections.append(Section(id: (child as AnyObject).key, name: dict["name"] as! String))
                index += 1
            }
//            for index in 0...self.sections.count-1 {
//                print("Section: \(self.sections[index].id) : \(self.sections[index].name)")
//            }
            self.tableView.reloadData()
        })
    }
    

    deinit {
        if let refHandle = communitySectionsRefHandle {
            communitySectionsRef.removeObserver(withHandle: refHandle)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.row]
        self.performSegue(withIdentifier: "showSection", sender: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cuisineCell") as? CuisineTableViewCell {
            cell.cuisineImage.image = UIImage(named: "\(indexPath.row+1)")
            cell.cuisineLabel.text = sections[indexPath.row].name
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("\(cuisinearray.count)")
        return sections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        if let section = sender as? Section {
            let MasterChatVc = segue.destination as! MasterChatViewController
            let chatVc = ChatViewController()
//            MasterChatVc.titleString = titleString
            MasterChatVc.section = sender as! Section
            MasterChatVc.communitySectionsRef = communitySectionsRef.child(section.id)
            print("SECTION REF: \(communitySectionsRef)")
            print("WHAT IS NIL : \(communitySectionsRef.child(section.id))")
            chatVc.communitySectionsRef = communitySectionsRef.child(section.id)
            print("SECTION ID = \(section.id)")
            print("SECTION REF PASSED: \(communitySectionsRef.child(section.id))")
        }
        
    }

}
