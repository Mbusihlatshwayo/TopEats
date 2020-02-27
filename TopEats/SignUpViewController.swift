//
//  SignUpViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/19/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // MARK: OUTLETS
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var usernameTextField: CustomTextField!
    
    // MARK: PROPERTIES
    var activityIndicator: NVActivityIndicatorView?
    
    // MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        self.navigationController?.navigationBar.isHidden = true

        
    }
    
    // MARK: CUSTOM FUNCTIONS
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
    func showActivityIndicator() {
        let centerFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = NVActivityIndicatorView(frame: centerFrame, type: .ballPulseSync, color: topEatsGreen)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    // MARK: IBACTIONS
    @IBAction func signInPressed(_ sender: Any) {
        //self.dismiss(self, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        
        if passwordTextField.text != confirmPasswordTextField.text {
            showAlert(alertTitle: "Sorry", alertMessage: "Passwords do not match")
            return
        }
        self.view.isUserInteractionEnabled = false
        showActivityIndicator()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            // there was a problem show the error to the user
            if error != nil {
                self.view.isUserInteractionEnabled = true
                self.activityIndicator?.stopAnimating()
                self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error!))
            }else{
                // no error sign in now
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    if error == nil {
                        // user was found sign them in and go forward
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.usernameTextField.text!
                        changeRequest?.commitChanges { (error) in
                            if error != nil {
                                self.activityIndicator?.stopAnimating()
                                self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error!))
                                self.view.isUserInteractionEnabled = true
                            } else {
                                // segue to main view
                                self.activityIndicator?.stopAnimating()
                                self.clearTextFields()
                                self.view.isUserInteractionEnabled = true
                                self.performSegue(withIdentifier: "segueToMaster", sender: nil)
                            }
                        }

                    } else {
                        // error
                        self.activityIndicator?.stopAnimating()
                        self.view.isUserInteractionEnabled = true
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
