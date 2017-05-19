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
        setupView()
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
