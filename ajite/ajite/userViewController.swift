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
    
    @IBOutlet var nameBox: UILabel!
    var userToDB = UserDB(name: user.profile.name)
    
    
    @IBOutlet var userTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let userRef = db.collection("userlist")
    let userData = db.collection("userlist").document("name")
    
    var userArray = [UserDB]()
    var collectionRef = Firestore.firestore().collection("userlist")
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func userDataAdd(){
        
        let dataForAdd: [String: Any] = [
            "name" : user.profile.name as Any,
            "id" : user.userID as Any
        ]
        
        db.collection("userlist").whereField("name", isEqualTo: true).getDocuments(){ (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let username = data["name"] as? String
                    
                    let newUserArray = UserDB(name: username!)
                    self.userArray.append(newUserArray)
                }
            }
            self.userTable.reloadData()
            
        }
    }
    
    func userDataGet(){
        userData.getDocument{(document, error) in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataAdd()
        userTable.delegate = self
        userTable.dataSource = self
        userTable.estimatedRowHeight = 80
        userTable.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension userViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
    
        cell.configureCell(userDB: userArray[indexPath.row])
        return cell
    }
}
