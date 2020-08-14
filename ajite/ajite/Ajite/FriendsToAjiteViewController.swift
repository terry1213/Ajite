//
//  FriendsToAjiteViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//


import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import GoogleSignIn
import FirebaseFirestore

var totalUser: [User] = []

class FriendsToAjiteViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    // if vcindex = 0 this request is from CreateAjite
    // if vcindex = 1 this request is from AjiteRoomView
    var vcindex = 0
    var displayUsers: [User] = []
    var addedMembers = [User]() // 아지트에 새로 넣을 멤버들
    var alreadyMembers = [String]() // 이미 아지트에 있는 멤버들 (vcindex == 1인 경우)
    var delegate : FriendsToAjiteDelegate?
    let userRef = db.collection("users")
    var currentAjite = Ajite()
    
    @IBOutlet weak var searchFriendsTable: UITableView!
    @IBOutlet weak var addedMembersTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addedMembersTable.dataSource = self
        self.addedMembersTable.delegate = self
        self.searchFriendsTable.dataSource = self
        self.searchFriendsTable.delegate = self
        searchBar.delegate = self
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayUsers.removeAll()
        addedMembers.removeAll()
        alreadyMembers.removeAll()
        totalUser.removeAll()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func invitation(_ sender: UIButton) {
        if vcindex == 1 {
            print("vcindex = 1")
            let inviteAlert = UIAlertController(title: "Invite to Ajite", message: "Would you like to invite friends to your ajite?", preferredStyle: UIAlertController.Style.alert)
            inviteAlert.addAction(UIAlertAction(title: "Add",style: .default, handler: {(action: UIAlertAction!) in
            
                for addedUser in self.addedMembers{
                    self.userRef.document(addedUser.documentID).collection("invitation").document(addedUser.documentID).setData([
                        "ajite" :  self.currentAjite.name,
                        "profileImageURL" : addedUser.profileImageURL
                    ])
                    db.collection("ajites").document(self.currentAjite.ajiteID).collection("members").document(addedUser.documentID).updateData([
                        "name":addedUser.name,
                        "userID":addedUser.userID,
                        
                    ])
                }
            }))
            inviteAlert.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler: nil))
            
            self.present(inviteAlert, animated: true, completion: nil)
        }
        else {
            self.delegate?.sendUsersBack(sendingMembers: addedMembers)
        }
        dismiss(animated: true)
    }
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getUserData(){
        if vcindex == 1 {
            db.collection("ajites").document(currentAjite.ajiteID).collection("members").getDocuments{ (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                }
                else {
                    self.userRef.getDocuments{ (snapshot, error) in
                        if let err = error {
                            debugPrint("Error fetching docs: \(err)")
                        }
                        else {
                            guard let snap = snapshot else {return}
                            for document in snap.documents {
                                var temMemberName : String
                                let data = document.data()
                                temMemberName = data["name"] as! String
                                self.alreadyMembers.append(temMemberName)
                                print("member: ", temMemberName)
                            }
                        }
                    }
                }
            }
        }
        
        userRef.document(myUser.documentID)
            .collection("friends").whereField("state", isEqualTo: 2).getDocuments{ (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                }
                else {
                    guard let snap = snapshot else {return}
                    var count = 0
                    for document in snap.documents {
                        //유저가 본인일 경우 리스트에 추가하지 않고 다음으로 넘어간다.
                        //유저가 멤버에 있을 때에도 넘어간다
                        if document.documentID == myUser.documentID || self.alreadyMembers.contains(document.documentID) {
                            continue
                        }
                        db.collection("users").document(document.documentID).getDocument { (document, error) in
                            var temUser : User
                            if let document = document, document.exists {
                                temUser = User()
                                let data = document.data()
                                temUser = User()
                                temUser.name = data!["name"] as! String
                                temUser.userID = data!["userID"] as! String
                                temUser.profileImageURL = data!["profileImageURL"] as! String
                                temUser.documentID = document.documentID
                                //전체 유저 목록에 추가
                               totalUser.append(temUser)
                                //테이블에 불러온 정보를 보여준다.
                                count += 1
                                if count == snap.documents.count {
                                    self.searchFriendsTable.reloadData()
                                    self.addedMembersTable.reloadData()
                                }
                            }
                            else {
                                    print("Document does not exist")
                            }
                        }
                    }
                }
            }
    }
    
    // ==================================================================>
    
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


extension FriendsToAjiteViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.addedMembersTable{
            return addedMembers.count
        } else {
            return displayUsers.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.addedMembersTable{
            addedMembersTable.deselectRow(at: indexPath, animated: true)
        }
        else{
            addedMembers.append(displayUsers[indexPath.row])
            displayUsers.remove(at: indexPath.row)
            //  searchFriendsTable.deselectRow(at: indexPath, animated: true)
            searchFriendsTable.reloadData()
            addedMembersTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.addedMembersTable{
            let cell = addedMembersTable.dequeueReusableCell(withIdentifier: "addedMembers", for: indexPath) as! AddedFriendsTableViewCell
            cell.addedMembersLabel.text = addedMembers[indexPath.row].name
            let data = try? Data(contentsOf: URL(string: addedMembers[indexPath.row].profileImageURL)!)
            cell.addedFriendsProfile.image = UIImage(data: data!)
            return cell
        }
        else if tableView == self.searchFriendsTable{
            let cell = searchFriendsTable.dequeueReusableCell(withIdentifier: "searchFriends", for: indexPath) as! searchFriendsTableViewCell
            cell.searchFriendName.text = displayUsers[indexPath.row].name
            //     cell.searchUser = myUser.friends 에 저장
            let data = try? Data(contentsOf: URL(string: displayUsers[indexPath.row].profileImageURL)!)
            cell.searchFriendImage.image = UIImage(data: data!)
            //cell.cellDelegate = self
            //cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    //search bar 에서 실수로 추가한 아이가 있으면 실수로 added member에 추가된 유저를 다시 삭제하는 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.addedMembersTable{
            guard editingStyle == .delete else { return }
            displayUsers.append(addedMembers[indexPath.row])
            addedMembers.remove(at: indexPath.row)
            
            self.addedMembersTable.deleteRows(at: [indexPath], with: .automatic)
        }
        searchFriendsTable.reloadData()
        addedMembersTable.reloadData()
    }
        
}


extension FriendsToAjiteViewController: UITableViewDelegate {
}

extension FriendsToAjiteViewController: UISearchBarDelegate {
    
    //필터링
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayUsers = totalUser.filter{ $0.name.contains(searchBar.text!) || $0.userID.contains(searchBar.text!) }
        searchFriendsTable.reloadData()
    }
    
    //검색 종료 버튼을 눌렀을 경우
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //검색어 입력 칸을 비운다.
        searchBar.text = ""
    }
    
}

protocol FriendsToAjiteDelegate {
    
    func sendUsersBack(sendingMembers : [User])
    
}
