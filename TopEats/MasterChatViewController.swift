//
//  MasterChatViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/30/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class MasterChatViewController: UIViewController {

    // PROPERTIES
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
