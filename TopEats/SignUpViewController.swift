//
//  SignUpViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var usernameTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        //self.dismiss(self, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }else{
                print("success!!!")
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    if let fireUser = user {
                        // user was found sign them in and go forward
                        print("USER: \(fireUser)")
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.usernameTextField.text!
                        changeRequest?.commitChanges { (error) in
                            if error != nil {
                                print("TROUBLE CHANGING DISPLAY NAME...\(error?.localizedDescription)")
                            } else {
                                print("INSIDE CLOSURE no trouble: \(fireUser.displayName)")
                            }
                        }
                        self.performSegue(withIdentifier: "masterSegue", sender: nil)
                    } else {
                        // error
                        print("\(String(describing: error))")
//                        self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error))
                        
                    }
                }

                
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
