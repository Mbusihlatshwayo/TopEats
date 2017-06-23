//
//  MasterViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/17/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var savedContainer: UIView!
    @IBOutlet weak var communityContainer: UIView!
    @IBOutlet weak var featuredContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var featuredContainerView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    // MARK: - PROPERTIES
    var menuShowing = false
    
    // MARK: - VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.alpha = 0
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView() {
        // do view stuff here
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        updateView()
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            featuredContainer.isHidden = false
            communityContainer.isHidden = true
            savedContainer.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            featuredContainer.isHidden = true
            communityContainer.isHidden = false
            savedContainer.isHidden = true
        } else {
            featuredContainer.isHidden = true
            communityContainer.isHidden = true
            savedContainer.isHidden = false
        }
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func showMenu(_ sender: Any) {
        if menuShowing {
            leadingConstraint.constant = -246
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 0
            }

        } else {
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 1
            }
        }
        menuShowing = !menuShowing
    }
    @IBAction func didPressLogOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("error \(signOutError)")
            return
        }
        self.dismiss(animated: true)

        
    }
    @IBAction func showFeaturedView(_ sender: Any) {
        featuredContainer.isHidden = false
        communityContainer.isHidden = true
        savedContainer.isHidden = true
        if menuShowing {
            leadingConstraint.constant = -246
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 0
            }
        } else {
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 1
            }
        }
        segmentedControl.selectedSegmentIndex = 0
        menuShowing = !menuShowing
    }
    
    @IBAction func showCommunityView(_ sender: Any) {
        featuredContainer.isHidden = true
        communityContainer.isHidden = false
        savedContainer.isHidden = true
        if menuShowing {
            leadingConstraint.constant = -246
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 0
            }
        } else {
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 1
            }
        }
        segmentedControl.selectedSegmentIndex = 1
        menuShowing = !menuShowing
    }
    
    @IBAction func showSavedView(_ sender: Any) {
        featuredContainer.isHidden = true
        communityContainer.isHidden = true
        savedContainer.isHidden = false
        if menuShowing {
            leadingConstraint.constant = -246
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 0
            }
        } else {
            leadingConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.menuView.layer.shadowOpacity = 1
            }
        }
        segmentedControl.selectedSegmentIndex = 2
        menuShowing = !menuShowing
    }
    
    @IBAction func didPressSearch(_ sender: Any) {
//        performSegue(withIdentifier: "showSearch", sender: nil)
    }
    
    
}
