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
var users: [User] = []

class userViewController: UIViewController {
    
    @IBOutlet var userTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let userRef = db.collection("users")
    
    //화면에 보일 유저 정보(검색창을 통해 필터링한 목록)
    var displayUsers: [User] = []
    
    func getUserData(){
        userRef.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    //유저가 본인일 경우 리스트에 추가하지 않고 다음으로 넘어간다.
                    if data["userID"] as? String == user.profile.email {
                        continue
                    }
                    let username = data["name"] as? String
                    let userID = data["userID"] as? String
                    let documentID = data["documentID"] as? String
                    let temUser = User()
                    temUser.name = username!
                    temUser.userID = userID!
                    temUser.documentID = documentID!
                    
                    
                    
                    
                    //전체 유저 목록에 추가
                    users.append(temUser)
                }
            }
            self.userTable.reloadData()
        }
    }
    
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users.removeAll()
        userTable.delegate = self
        userTable.dataSource = self
        getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension userViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        cell.nameLabel?.text = displayUsers[indexPath.row].name
        cell.userIdLabel.text = displayUsers[indexPath.row].userID
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
}

extension userViewController: UISearchBarDelegate {
    //검색창에 키 입력이 될 시
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayUsers = users.filter{ $0.name.contains(searchBar.text!) || $0.userID.contains(searchBar.text!) }
        userTable.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 70
         }
    
    //검색 종료 버튼을 눌렀을 경우
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //검색어 입력 칸을 비운다.
        searchBar.text = ""
    }
}

extension userViewController: TableViewUser {
    func onClickCell(index: Int){
        print(displayUsers[index].documentID)
        db.collection("users").document("\(displayUsers[index].documentID)").updateData([
            /*"userID":  displayUsers[index].userID,
            "name": displayUsers[index].name,
            
            "documentID": displayUsers[index].documentID,*/
            "request": user.profile.name as Any
        ])
    }
}

