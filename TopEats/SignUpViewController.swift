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
    
    func clearTextFields() {
        
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        emailTextField.text = ""
        usernameTextField.text = ""
        
    }
    func showAlert(alertTitle: String, alertMessage: String) {
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        //self.dismiss(self, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if error != nil {
                return
            }else{
                self.clearTextFields()
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    if user != nil {
                        // user was found sign them in and go forward
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.usernameTextField.text!
                        changeRequest?.commitChanges { (error) in
                            if error != nil {

                            } else {

                            }
                        }
                        self.performSegue(withIdentifier: "masterSegue", sender: nil)
                    } else {
                        // error
                        self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error))
                        
                    }
                }

                
            }
        })
    }
    // MARK: - TEXT FIELD METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            passwordTextField.isSecureTextEntry = true
        }
        if textField == confirmPasswordTextField {
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }

}
