//
//  HomeViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var feedTableView: UITableView!
    let youtubePlayerViewController = YoutubePlayerViewController()
    var feedTableShortConstraint: NSLayoutConstraint?
    var feedTableFullConstraint: NSLayoutConstraint?
    var searchBarHighConstraint: NSLayoutConstraint?
    var searchBarLowConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFeedTableViewConstraints()
        setSearchBarViewConstraints()
        // Do any additional setup after loading the view.
    }
    
    func addChildVC() {
        addChild(youtubePlayerViewController)
        view.addSubview(youtubePlayerViewController.view)
        youtubePlayerViewController.didMove(toParent: self)
        setYoutubePlayerVCConstraints()
    }

    func setFeedTableViewConstraints() {
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableFullConstraint = view.constraints.first { $0.identifier == "FeedTableViewTop" }
        //feedTableFullConstraint = feedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54)
        feedTableFullConstraint?.isActive = true
        feedTableShortConstraint = feedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250)
        feedTableShortConstraint?.isActive = false
    }
    
    func toggleFeedTableViewConstraints() {
        feedTableFullConstraint?.isActive = !(feedTableFullConstraint?.isActive)!
        feedTableShortConstraint?.isActive = !(feedTableShortConstraint?.isActive)!
    }
    
    func setSearchBarViewConstraints() {
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarHighConstraint = view.constraints.first { $0.identifier == "SearchBarViewTop" }
        //searchBarHighConstraint = searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        searchBarHighConstraint?.isActive = true
        searchBarLowConstraint = searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196)
        searchBarLowConstraint?.isActive = false
    }
    
    func toggleSearchBarViewConstraints() {
        searchBarLowConstraint?.isActive = !(searchBarLowConstraint?.isActive)!
        searchBarHighConstraint?.isActive = !(searchBarHighConstraint?.isActive)!
    }
    
    func setYoutubePlayerVCConstraints() {
        youtubePlayerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        youtubePlayerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        youtubePlayerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        youtubePlayerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        youtubePlayerViewController.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    @IBAction func test(_ sender: Any) {
        toggleFeedTableViewConstraints()
        toggleSearchBarViewConstraints()
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        else {
            addChildVC()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
