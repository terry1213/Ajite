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

class userlistTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    @IBOutlet var userlistTableView: UITableView!
    
    var userArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var loggedInUser:User?
    
    var testArray = [NSDictionary?]()
    
    //var ref: DatabaseReference!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var ref = Database.database().reference()
    
    
    var userlist = [User]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        
        return self.userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    private let database = Database.database().reference()
    
    @objc private func addNewEntry(){
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        let object: [String: Any] = [
            "name" : user.profile.name as NSObject
        ]
        database.child("user").child("\(String(describing: user.userID))").setValue(object)
        
    }
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
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "name")
            
            if(key == self.loggedInUser?.userID){
                print("Same as logged in user, so don't show!")
            }
            else{
                self.userArray.append(snapshot)
                self.userlistTableView.insertRows(at: [IndexPath(row:self.userArray.count-1,section: 0)],with: UITableView.RowAnimation.automatic)
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
