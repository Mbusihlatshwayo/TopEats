//
//  ViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/13/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        
        // if user is signed in bypass login
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginToMaster", sender: nil)
            }
        }
        
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: nil)
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
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if user != nil {
                        // user was found sign them in and go forward
                        self.performSegue(withIdentifier: "loginToMaster", sender: nil)
                        self.passwordLabel.text = ""
                        self.usernameLabel.text = ""
                    } else {
                        // error
                        self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error))

                    }
                }
            } else {
                showAlert(alertTitle: "Sorry", alertMessage: "Please enter email and password")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordLabel {
            passwordLabel.isSecureTextEntry = true
        }
    }

}

