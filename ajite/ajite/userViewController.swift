//
//  userViewController.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

let db = Firestore.firestore()
let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser

public struct UserDB: Codable {
    let name: String
    
}

class userViewController: UIViewController {
    
    @IBOutlet var userTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let userRef = db.collection("userlist")
    let userData = db.collection("userlist").document(user.userID)
    
    
    var userListData = [String]()
    var userArray = [String]()
    var collectionRef = Firestore.firestore().collection("userlist")
    
    var searching = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func userDataAdd(){
        
        // Add a new document in collection "cities"
        db.collection("userlist").document(user.userID).setData([
            "id": user.userID as Any,
            "name": user.profile.name as Any
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func userDataGet(){
        
        
        userRef.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    print(document.data())
                    let data = document.data()
                    let username = data["name"] as? String
                    self.userArray.append(username!)
                    self.userListData.append(username!)
                }
            }
            self.userTable.reloadData()
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTable.delegate = self
        userTable.dataSource = self
        userTable.estimatedRowHeight = 80
        userTable.rowHeight = UITableView.automaticDimension
        userDataAdd()
        userDataGet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension userViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return userArray.count
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
    
        //cell.configureCell(userDB: userArray[indexPath.row])
        
        if searching {
            cell.nameBox?.text = userListData[indexPath.row]
        }
        else{
            cell.nameBox?.text = userArray[indexPath.row]
        }
        return cell
    }
    
    func sendRequest(sender: UIButton!){
        sender.isSelected = !sender.isSelected
        
        
    }
}

extension userViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        userArray = userListData.filter({$0.contains(searchBar.text!)})
        searching = true
        userTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        userTable.reloadData()
    }
}
