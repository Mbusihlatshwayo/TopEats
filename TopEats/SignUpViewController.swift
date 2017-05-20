//
//  SignUpViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var passwordLabel: CustomTextField!
    @IBOutlet weak var confirmPasswordLabel: CustomTextField!

    @IBOutlet weak var emailLabel: CustomTextField!
    @IBOutlet weak var usernameLabel: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        //self.dismiss(self, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        NetworkingServices.createUser(email: emailLabel.text!, password: passwordLabel.text!)
    }

}
