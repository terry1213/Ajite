//
//  FriendsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/13.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var searchFriends: UISearchBar!
    @IBOutlet weak var friendsList: UITableView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터 불러오기
        getFriendsList() {
            //테이블에 불러온 정보를 보여준다.
            self.friendsList.reloadData()
        }
        self.friendsList.delegate = self
        self.friendsList.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toFriendsProfile" else {
            return
        }
        guard let sendingUser = sender as? User else {
            return
        }
        guard let destination = segue.destination as? FriendsProfileViewController else {
            return
        }
        destination.currentUser = sendingUser
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    // 친구 리스트를 불러오는 함수
    func getFriendsList(completion: @escaping () -> Void){
        //유저 documentID를 통해 친구 목록에서 친구 사이의 유저 documentID를 불러온다.
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").whereField("state", isEqualTo: 2).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    //데이터 중복을 막기 위해 원래 불러왔던 친구 목록을 삭제한다.
                    myUser.friends.removeAll()
                    var count = 0
                    for friendDocument in querySnapshot!.documents {
                        self.getFriendData(friendDocumentID: friendDocument.documentID) {
                            count += 1
                            if count == querySnapshot!.documents.count{
                                completion()
                            }
                        }
                    }
                }
        }
    }
    
    // 친구의 정보를 불러오는 함수
    func getFriendData(friendDocumentID : String, completion: @escaping () -> Void){
        //친구의 documentID를 통해 친구의 users document 정보 접근
        db
            .collection("users").document(friendDocumentID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    //임시로 저장할 유저 변수 생성
                    let temUser = User()
                    //유저 이메일 아이디 저장
                    temUser.userID = data!["userID"] as! String
                    //유저 이름 저장
                    temUser.name = data!["name"] as! String
                    //유저의 프로필 이미지 url 저장
                    temUser.profileImageURL = data!["profileImageURL"] as! String
                    //유저의 documentID 저장
                    temUser.documentID = document.documentID
                    //친구 목록에 추가
                    myUser.friends.append(temUser)
                    completion()
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    // ==================================================================>
    
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsList.dequeueReusableCell(withIdentifier: "ManageFriendsTableViewCell", for: indexPath) as! ManageFriendsTableViewCell
        cell.userName.text = myUser.friends[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: myUser.friends[indexPath.row].profileImageURL)!)
        cell.profileImage.image = UIImage(data: data!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToSend = myUser.friends[indexPath.row]
        self.performSegue(withIdentifier: "toFriendsProfile", sender: dataToSend)
        friendsList.deselectRow(at: indexPath, animated: true)
    }
    
}
