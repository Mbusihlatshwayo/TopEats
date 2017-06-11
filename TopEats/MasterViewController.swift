//
//  MasterViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/17/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var savedContainer: UIView!
    @IBOutlet weak var communityContainer: UIView!
    @IBOutlet weak var featuredContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var featuredContainerView: UIView!
    
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
    
    
    
}
