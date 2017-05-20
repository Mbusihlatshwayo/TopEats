//
//  ViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/13/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpController = storyboard.instantiateViewController(withIdentifier: "signUpView") as! SignUpViewController
        
        self.present(signUpController, animated: true, completion: nil)
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func signInPressed(_ sender: Any) {
        if let email = usernameLabel.text, let password = passwordLabel.text {
            if email != "" {
                print("email: \(email)")
                FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                    if let fireUser = user {
                        // user was found sign them in and go forward
                        print("USER: \(fireUser)")
                    } else {
                        // error
                        print("\(String(describing: error))")
                        self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error))

                    }
                }
            } else {
                showAlert(alertTitle: "Sorry", alertMessage: "Please enter email and password")
            }
        }
    }


}

