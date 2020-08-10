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
    var memberViewAjite = Ajite()
    @IBOutlet var memberTableView: UITableView!
    
    
    let currentAjite = Ajite()
    func getUserRequest(){
        db
            .collection("ajites").document(memberViewAjite.ajiteID).collection("members").getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    print("member document loading")
                    let data = document.data()
                    let membername = data["name"] as? String
                    let memberID = data["userID"] as? String
                    let temUser = User()
                    temUser.name = membername!
                    temUser.userID = memberID!
                    //전체 유저 목록에 추가
                    print("\(String(describing: membername))")
                    member.append(temUser)
                }
            }
            self.memberTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member.removeAll()
        memberTableView.dataSource = self
        memberTableView.delegate = self
        getUserRequest()
        // Do any additional setup after loading the view.
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
