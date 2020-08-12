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

    
    var vcindex = 0
    //if vcindex = 0 this request is from CreateAjite
    //if vcindex = 1 this request is from AjiteRoomView
    var displayUsers: [User] = []
    var addedMembers = [User]() //아지트에 새로 넣을 멤버들
    var alreadyMembers = [String]() // 이미 아지트에 있는 멤버들 (vcindex == 1인 경우)
    var delegate : FriendsToAjiteDelegate?
    let userRef = db.collection("users")
    var currentAjite = Ajite()
    @IBOutlet weak var searchFriendsTable: UITableView!
    @IBOutlet weak var addedMembersTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
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
                                self.userRef.document(myUser.documentID).collection("friends").whereField("state", isEqualTo: 2).getDocuments{ (snapshot, error) in
                                    if let err = error {
                                        debugPrint("Error fetching docs: \(err)")
                                    }
                                    else {
                                        guard let snap = snapshot else {return}
                                        var count = 0
                                        for document in snap.documents {
                                            //유저가 멤버에 있을 때 넘어간다
                                            if self.alreadyMembers.contains(document.documentID) {
                                                continue
                                            }
                                            db.collection("users").document(document.documentID).getDocument { (document, error) in
                                                var tempUser : User
                                                if let document = document, document.exists {
                                                    tempUser = User()
                                                    let data = document.data()
                                                    tempUser = User()
                                                    tempUser.name = data!["name"] as! String
                                                    tempUser.userID = data!["userID"] as! String
                                                    tempUser.profileImageURL = data!["profileImageURL"] as! String
                                                    tempUser.documentID = document.documentID
                                                    //전체 유저 목록에 추가
                                                    totalUser.append(tempUser)
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
                        }
                    }
                }
            }
        }
        else{
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
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
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayUsers = totalUser.filter{ $0.name.contains(searchBar.text!) || $0.userID.contains(searchBar.text!) }
        searchFriendsTable.reloadData()
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
  /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dataToSend = playlists[indexPath.row]
    self.performSegue(withIdentifier: "toPlaylist", sender: dataToSend)*/
    //위 코드는 segue를 통해 데이터를 다른 뷰 컨트롤러로 보내는건데 우리의 경우에는 createAjiteViewController이면 생성될 아지트의 멤버 옵젝트와 연결하는게 맞고 segue가 이미 생성된 아지트 내에 추가적으로 애드 할 거면 이제 그 생성될 아지트 내에 멤버 오브젝트에 추가하는게 맞고 ㅇㅇ
   // }
}

extension FriendsToAjiteViewController: UISearchBarDelegate {
    
    //필터링
    
    
    //검색 종료 버튼을 눌렀을 경우
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //검색어 입력 칸을 비운다.
        searchBar.text = ""
    }
}


protocol FriendsToAjiteDelegate {
    func sendUsersBack(sendingMembers : [User])
    
}
