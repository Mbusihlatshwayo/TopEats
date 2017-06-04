//
//  MasterChatViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/30/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class MasterChatViewController: UIViewController {

    //MARK: - PROPERTIES
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var section: Section!
    var communitySectionsRef: DatabaseReference?
    
    //MARK:  VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = section.name
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.communitySectionsRef = communitySectionsRef
            print("detail CHAT VC Ref = \(String(describing: chatVC.communitySectionsRef!))")
        }
    }

}
