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
var users: [User] = []

class userViewController: UIViewController {
    
    @IBOutlet var userTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let userRef = db.collection("users")
    
    //화면에 보일 유저 정보(검색창을 통해 필터링한 목록)
    var displayUsers: [User] = []
    var friendsID : [String] = []
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users.removeAll()
        userTable.delegate = self
        userTable.dataSource = self
        //모든 친구 목록을 불러온다.
        getfriendsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserData(){
        //모든 유저 정보를 불러온다.
        userRef.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                var temUser : User
                for document in snap.documents {
                    let data = document.data()
                    //유저가 본인일 경우 리스트에 추가하지 않고 다음으로 넘어간다.
                    if data["userID"] as? String == myUser.userID {
                        continue
                    }
                    temUser = User()
                    temUser.userID = data["userID"] as! String
                    temUser.name = data["name"] as! String
                    temUser.profileImageURL = data["profileImageURL"] as! String
                    temUser.documentID = document.documentID
                    //전체 유저 목록에 추가
                    users.append(temUser)
                }
            }
        }
    }
    
    func getfriendsData() {
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.friendsID.append(document.documentID)
                    }
                    //모든 유저 정보를 불러온다.
                    self.getUserData()
                }
            }
    }
    
    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension userViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTable.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        cell.nameLabel?.text = displayUsers[indexPath.row].name
        cell.userIdLabel.text = displayUsers[indexPath.row].userID
        let data = try? Data(contentsOf: URL(string: displayUsers[indexPath.row].profileImageURL)!)
        cell.userProfileImage.image = UIImage(data: data!)
        cell.cellDelegate = self
        cell.delegate = self
        cell.index = indexPath
        if self.friendsID.contains(displayUsers[indexPath.row].documentID) {
            cell.sendButton.isHidden = true
        }
        else {
            cell.sendButton.isHidden = false
        }
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
        //친구 신청을 받는 유저의 friends collection에 friend document를 생성한다. state = 1
        db.collection("users").document(displayUsers[index].documentID).collection("friends").document(myUser.documentID).setData([
                "userID" : myUser.userID as Any,
                "name" : myUser.name as Any,
                /*
                 친구 state 설명:
                    0 = 친구 신청 보냄
                    1 = 친구 신청 받음
                    2 = 친구 상태
                    거절하면 document 자체를 삭제
                 */
                "state" : 1
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
        //친구 신청을 하는 유저의 friends collection에 friend document를 생성한다. state = 0
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").document(displayUsers[index].documentID).setData([
                "userID" : displayUsers[index].userID as Any,
                "name" : displayUsers[index].name as Any,
                /*
                 친구 state 설명:
                    0 = 친구 신청 보냄
                    1 = 친구 신청 받음
                    2 = 친구 상태
                    거절하면 document 자체를 삭제
                 */
                "state" : 0
            ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                }
            }
    }
}

extension userViewController : UserTableViewCellDelegate{
    func sendMessage(_ UserTableViewCell: UserTableViewCell) {
        let alert = UIAlertController (title: "Sent Request!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
