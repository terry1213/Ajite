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

class userlistViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //var ref: DatabaseReference!
    
    var ref = Database.database().reference()
    
    
    var userlist = [User]()
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var nameBox: UILabel!
    @IBOutlet var checkBox: UIButton!
    
    /*
    func dataRead() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("user").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let user = User(username: username)
        }, withCancel: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBOutlet var checkButton: UIButton!
    
    @IBOutlet var userName: UILabel!
    @IBAction func searchCheckBtn(_ sender: Any) {
    }
    
    private let database = Database.database().reference()
    
    
    func dataAdd() {
        let UserRef =  Database.database().reference().child("user").childByAutoId()
        //친구신청 수락시 추가
        /*let userObject = [
            
        ] as [String: Any]
        */
    }
    
    @objc private func addNewEntry(){
        let object: [String: Any] = [
            "name" : "Ajite" as NSObject,
            "Youtube": "yes"
        ]
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        
        
        database.child(user.profile.name).setValue(object)
    }
    
    
    func dataRead() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("user").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["user"] as? String
            //let user = User(username: username)
        }){
            (error) in print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkButton.addTarget(self, action: #selector(addNewEntry) , for: .touchUpInside)
        
        //로그인 계정 데이터베이스에 추가
        addNewEntry()
        //userName
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = "검색할 사람을 입력하세요"
        
        
        
        
        /*
        database.child("user").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            print("value: \(value)")
        })*/
    }
    /*
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("유저리스트").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        let homeController = HomeViewController()
        present(homeController,animated: true, completion: nil)
    }
    
    */
}
