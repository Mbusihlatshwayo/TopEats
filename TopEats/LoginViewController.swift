//
//  ViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/13/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: CustomTextField!

    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        setUpActivityIndicator()
        self.navigationController?.navigationBar.isHidden = true
        // if user is signed in bypass login
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.activityIndicator?.stopAnimating()
                self.dismiss(animated: false)

//                self.performSegue(withIdentifier: "loginToMaster", sender: nil)
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Master", bundle: nil)
                let vc : MasterViewController = storyboard.instantiateViewController(withIdentifier: "masterView") as! MasterViewController
                vc.modalPresentationStyle = .fullScreen

                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true, completion: nil)
                
            } else {
                self.activityIndicator?.stopAnimating()
            }
        }
        
    }
    
    func setUpActivityIndicator() {
        let centerFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = NVActivityIndicatorView(frame: centerFrame, type: .ballPulseSync, color: UIColor.white)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        if usernameLabel.text != "" {
            Auth.auth().sendPasswordReset(withEmail: usernameLabel.text!) { (error) in
                if error != nil {
                    self.showAlert(alertTitle: "Sorry", alertMessage: "\(String(describing: error))")
                } else {
                    self.showAlert(alertTitle: "Success", alertMessage: "Email Sent!")
                }
            }
        } else {
            showAlert(alertTitle: "Sorry", alertMessage: "Please enter the email of the account you wish to reset")
        }
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(ok)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func signInPressed(_ sender: Any) {
        if let email = usernameLabel.text, let password = passwordLabel.text {
            view.isUserInteractionEnabled = false
            if email != "" {
                setUpActivityIndicator()
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil {
                        // user was found sign them in and go forward
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator?.stopAnimating()
                        self.passwordLabel.text = ""
                        self.usernameLabel.text = ""
                    } else {
                        // error
                        self.view.isUserInteractionEnabled = true

                        self.activityIndicator?.stopAnimating()
                        self.showAlert(alertTitle: "Sorry", alertMessage: String(describing: error!))
                        

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

