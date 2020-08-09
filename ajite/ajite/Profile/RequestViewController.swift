//
//  RequestViewController.swift
//  
//
//  Created by Chanwoong Ahn on 2020/08/09.
//

import Foundation
import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

var RequestedUsers: [User] = []

class RequestViewController: UIViewController{
    @IBOutlet var RequestTV: UITableView!
    
    var RequestUsers: [User] = []
    
    func getUserRequest(){
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").whereField("state", isEqualTo: 1).getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let username = data["name"] as? String
                    let userID = data["userID"] as? String
                    let temUser = User()
                    temUser.name = username!
                    temUser.userID = userID!
                    temUser.documentID = document.documentID
                    //전체 유저 목록에 추가
                    self.RequestUsers.append(temUser)
                }
            }
            self.RequestTV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        RequestTV.delegate = self
        RequestTV.dataSource = self
        getUserRequest()
    }
    
}

extension RequestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RequestUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestTableViewCell
        cell.nameBox?.text = RequestUsers[indexPath.row].name
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    
}

extension RequestViewController: RequestTableViewUser {
    func AcceptClickCell(index: Int) {
        db
            .collection("users").document(RequestUsers[index].documentID)
            .collection("friends").document(myUser.documentID).updateData([
                /*
                 친구 state 설명:
                    0 = 친구 신청 보냄
                    1 = 친구 신청 받음
                    2 = 친구 상태
                    거절하면 document 자체를 삭제
                 */
                "state" : 2
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").document(RequestUsers[index].documentID).updateData([
                /*
                 친구 state 설명:
                    0 = 친구 신청 보냄
                    1 = 친구 신청 받음
                    2 = 친구 상태
                    거절하면 document 자체를 삭제
                 */
                "state" : 2
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.RequestUsers.remove(at: index)
                    self.RequestTV.reloadData()
                }
            }
    }
    
    func DeclineClickCell(index: Int) {
        db
            .collection("users").document(RequestUsers[index].documentID)
            .collection("friends").document(myUser.documentID).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                }
            }
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").document(RequestUsers[index].documentID).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted")
                    self.RequestUsers.remove(at: index)
                    self.RequestTV.reloadData()
                }
            }
    }
}
