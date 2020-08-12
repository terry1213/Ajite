//
//  MemberTableViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/06.
//  Copyright © 2020 ajite. All rights reserved.

import UIKit


//:::::::::::::해당아지트에 속한 멤버들을 보여주는 뷰 컨트롤러 :::::::::::::::::::

var member: [User] = []

class MemberViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var memberTableView: UITableView!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    
    var currentAjite = Ajite()
    var friendsID : [String] = []
    var friendOrNot : [Bool] = []
    func getUserRequest(){
        db
            .collection("ajites").document(currentAjite.ajiteID).collection("members").getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                guard let snap = snapshot else {return}
                var count = 0
                for document in snap.documents {
                    print("member document loading")
                    self.numberOfMembersLabel.text = "(\(snap.documents.count))"
                    db
                        .collection("users").document(document.documentID).getDocument { (document, error) in
                            var temUser : User
                            print(document!.documentID)
                            if let document = document, document.exists {
                                temUser = User()
                                let data = document.data()
                                temUser = User()
                                temUser.name = data!["name"] as! String
                                temUser.userID = data!["userID"] as! String
                                temUser.profileImageURL = data!["profileImageURL"] as! String
                                temUser.documentID = document.documentID
                                //유저 본인일 경우 제일 앞에 추가
                                if temUser.documentID == myUser.documentID {
                                    member.insert(temUser, at: 0)
                                    self.friendOrNot.insert(true, at: 0)
                                }
                                else {
                                    //아지트 맴버 목록에 추가
                                    member.append(temUser)
                                    if self.friendsID.contains(temUser.documentID) {
                                        self.friendOrNot.append(true)
                                    }
                                    else {
                                        self.friendOrNot.append(false)
                                    }
                                }
                                count += 1
                                if count == snap.documents.count {
                                    self.memberTableView.reloadData()
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
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
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member.removeAll()
        memberTableView.dataSource = self
        memberTableView.delegate = self
        getfriendsData()
        getUserRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           //self.memberTableView.reloadData()
    }
    
     
}


extension MemberViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! memberInAjiteTableViewCell
        cell.memberName.text =  member[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: member[indexPath.row].profileImageURL)!)
        cell.memberProfile.image = UIImage(data: data!)
        if friendOrNot[indexPath.row] == true {
            cell.sendFriendRequestButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
       indexPath: IndexPath) -> CGFloat {
               return 60
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMembersOriginal"{
            let vc = segue.destination as! FriendsToAjiteViewController
            vc.vcindex = 1
            vc.currentAjite = currentAjite
        }
    }
}

extension MemberViewController: memberTableView {
    func OnClickCell(index: Int) {
        
    }
    
    
    /*
     alert부분
    extension 문제로 임시 주석처리
     
    let sendInviteAlert = UIAlertController  (title: "invitation", message: "Would you like to send invitation", preferredStyle: UIAlertController.Style.alert)
    
    sendInviteAlert.addAction(title:)*/
    
    /*
    func OnClickCell(index: Int) {
        print(inviteUser[index].documentID)
        db
        .collection("users").document(inviteUser[index].documentID)
            .collection("invitedToAjite").document(myUser.documentID).setData([
            "초대한 사람" : myUser.name as Any
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }*/
    
    
}
