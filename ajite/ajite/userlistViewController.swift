//
//  userlistViewController.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/03.
//  Copyright © 2020 ajite. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn

class userlistViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    var userArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    
    //var ref: DatabaseReference!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var ref = Database.database().reference()
    
    
    var userlist = [User]()
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserlistTableViewCell
        let user: NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        }
        else
        {
            user = self.userArray[indexPath.row]
        }
        cell.nameBox.text = user?["name"] as? String
        return cell
    }
    
    @IBAction func searchCheckBtn(_ sender: Any) {
    }
    
    private let database = Database.database().reference()
    
    @objc private func addNewEntry(){
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let object: [String: Any] = [
            "name" : user.profile.name as NSObject
        ]
        database.child("user").child(user.profile.name).setValue(object)
        
    }
    
    /*
    func dataRead() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("user").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["user"] as? String
            //let user = User(username: username)
        }){
            (error) in print(error.localizedDescription)
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //로그인 계정 데이터베이스에 추가
        addNewEntry()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.searchBar.delegate = self
        //self.searchBar.placeholder = "검색할 사람을 입력하세요"
        
        ref = Database.database().reference().child("user")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        ref.child("user").queryOrdered(byChild: "name").observe(.childAdded, with: {(snapshot) in
            
            self.userArray.append(snapshot.value as? NSDictionary)
            
            self.tableView.insertRows(at: [IndexPath(row:self.userArray.count-1,section: 0)],with: UITableView.RowAnimation.automatic)
        })
    }
    
    @IBAction func dismissFollowUsersTableView(_sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText:String){
        self.filteredUsers = self.userArray.filter{ user in
            let username = user!["name"] as? String
            return(username?.lowercased().contains(searchText.lowercased()))!
            
        }
        tableView.reloadData()
    }
    
}
