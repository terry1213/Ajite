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
    
    let userRef = db.collection("users")
    
    var RequestUsers: [User] = []
    
    func getUserRequest(){
        userRef.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    //Request가 비었을 경우 넘어감
                    if data["request"] as? String == nil {
                        continue
                    }
                    
                    let username = data["name"] as? String
                    let userID = data["userID"] as? String
                    let documentID = data["documentID"] as? String
                    let request = data["request"] as? String
                    let temUser = User()
                    temUser.name = username!
                    temUser.userID = userID!
                    temUser.documentID = documentID!
                    temUser.request = request!
                    //전체 유저 목록에 추가
                    self.RequestUsers.append(temUser)
                    print(temUser.name)
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
        
        return cell
    }
    
    
}

extension RequestViewController: RequestTableViewUser {
    func AcceptClickCell(index: Int) {
        print(RequestUsers[index].documentID)
        db.collection("users").document("\(RequestUsers[index].documentID)").updateData([
            "userID":  RequestUsers[index].userID,
            "name": RequestUsers[index].name,
            
            "documentID": RequestUsers[index].documentID,
            "friend": user.profile.name as Any
        ])
        
        let ref: DocumentReference? = nil
        
        db.collection("users").document("\(String(describing: ref?.documentID))").updateData([
            "userID":  user.profile.email as Any,
            "name": user.profile.name as Any,
            
            "documentID": String(describing: ref?.documentID),
            "friend": RequestUsers[index].name as Any
        ])
    }
    
    func DeclineClickCell(index: Int) {
        let ref: DocumentReference? = nil
        
        db.collection("users").document("\(String(describing: ref?.documentID))").updateData([
            "userID":  user.profile.email as Any,
            "name": user.profile.name as Any,
            "documentID": String(describing: ref?.documentID),
            "request": ""
        ])
    }
}
