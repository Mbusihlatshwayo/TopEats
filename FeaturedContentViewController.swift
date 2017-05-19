//
//  FeaturedContentViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/17/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class FeaturedContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {

    @IBOutlet weak var featuredScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsObject: News!
    var newsObject1: News!
    var newsObject2: News!
    var newsArray = [News]()
    var currentPage: Int = 0
    var currentX: CGFloat!
    var previousX: CGFloat!
    var newX: CGFloat!
    var myTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.green
        featuredScrollView.isPagingEnabled = true
        featuredScrollView.showsVerticalScrollIndicator = false
        featuredScrollView.delegate = self
        /* ---------------------------------------- */
        myTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        setupDummyData()
        loadFeaturedItems() // send it off to load all data into featured view
    }
    override func viewDidAppear(_ animated: Bool) {
        print("big one appeared")
    }
    func setupDummyData() {
        /* create objects for table view dummy data */
        newsObject = News(image: "restaurant1", headText: "Dummy Headline", articleText: "It is a great place try it")
        newsObject1 = News(image: "restaurant2", headText: "Anotha one", articleText: "Really listen and give it a shot")
        newsObject2 = News(image: "restaurant3", headText: "Here", articleText: "We have nice food try it sometime")
        newsArray.append(newsObject)
        newsArray.append(newsObject1)
        newsArray.append(newsObject2)
        newsArray.append(newsObject1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        myTimer.invalidate()
    }
    
    func runTimedCode() {
        print("TIMER FIRED go to page \(currentPage)")
        let itemCount = newsArray.count // how many items are in the news reel
        if currentPage < itemCount {
            newX = CGFloat(currentPage) * self.view.frame.width // calculate next page position
            featuredScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
            currentPage += 1
        } else {
            // end of items
            currentPage = 0
            let newX = CGFloat(currentPage) * self.view.frame.width // calculate next page position
            featuredScrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFeaturedItems() {
        
        for (index, featuredNews) in newsArray.enumerated() {
            if let featuredNewsView = Bundle.main.loadNibNamed("FeaturedContent", owner: self, options: nil)?.first as? FeaturedContentView {
                featuredNewsView.featuredImage.image = UIImage(named: featuredNews.headlineImage)
                featuredNewsView.featuredLabel.text = featuredNews.headlineText
                
                featuredScrollView.addSubview(featuredNewsView)
                featuredNewsView.frame.size.width = self.view.bounds.width
                featuredNewsView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                featuredScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(newsArray.count), height: 225)
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // if the user dragged the carousel update the current page number
        if scrollView == featuredScrollView {
            currentX = featuredScrollView.contentOffset.x
            if currentX < newX {
                currentPage -= 1
            } else if currentX > newX {
                currentPage += 1
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? NewsTableViewCell {
            newsCell.configCell(news: newsArray[indexPath.row])
            return newsCell
        }
        else {
            return NewsTableViewCell()
        }
    }
    

}
