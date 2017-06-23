//
//  SearchViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 6/23/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    // MARK: - OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    var searchResults = [Place]()
    var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - TABLE VIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") {
            cell.textLabel?.text = searchResults[indexPath.row].name
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - SEARCH BAR DELEGATE METHODS 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            if (searchBar.text?.containsWhiteSpace())! {
                let text = searchBar.text!
                let first = text.replacingOccurrences(of: " ", with: "%20")
                let searchKeyword = "%22\(first)%22"
                performSearch(searchKeyword: searchKeyword)
            } else {
                performSearch(searchKeyword: searchBar.text!)
            }
            
        }
        self.view.endEditing(true)
    }
    // MARK: SEARCH FUNCTIONALITY
    func performSearch(searchKeyword: String) {
        print("INSIDE SEARCH FUNC")
        //        let centerFrame = CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 40, height: 40)
        let centerFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = NVActivityIndicatorView(frame: centerFrame, type: .ballPulseSync, color: topEatsGreen)
        activityIndicator?.center = view.center
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()

        NetworkingFunctionality.searchPlaces(searchKeyword: searchKeyword, completion: { [weak self] data in
            self?.searchResults = data
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.activityIndicator?.stopAnimating()
        })
        
    }
    
    // MARK: - IBACTIONS
    @IBAction func didPressBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension String {
    
    func containsWhiteSpace() -> Bool {
        
        // check if there's a range for a whitespace
        let range = self.rangeOfCharacter(from: .whitespaces)

        // returns false when there's no range for whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
    }
}
