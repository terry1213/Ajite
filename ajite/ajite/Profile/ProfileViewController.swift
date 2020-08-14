//
//  ProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    @IBOutlet weak var friendNumLabel: UILabel!
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var myFriendsTableView: UITableView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor =  .white
        super.viewDidLoad()
        addFriend.imageView?.contentMode = .scaleAspectFit
        self.myFriendsTableView.delegate = self
        self.myFriendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //데이터 불러오기
        getData()
        //Label에 이름 적기
        self.userNameLabel.text = myUser.name
        //Label에 biography 적기
        self.bio.text = myUser.bio
        //UIImage에 유저 프로필 사진 넣기
        let data = try? Data(contentsOf: URL(string: myUser.profileImageURL)!)
        self.profilePicture.image = UIImage(data: data!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toFriendProfile" else {
            return
        }
        guard let sendingUser = sender as? User else {
            return
        }
        guard let destination = segue.destination as? FriendProfileViewController else {
            return
        }
        destination.currentUser = sendingUser
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func getData(){
        //유저 정보 불러오기
        db
            .collection("users").document(myUser.documentID)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    //전역 변수인 myUser에 데이터 저장
                    myUser.bio = document.data()!["bio"] == nil ? "" : document.data()!["bio"] as! String
                    self.bio.text = myUser.bio
                } else {
                    print("Document does not exist")
                }
            }
        //유저 documentID를 통해 친구 목록에서 친구 사이의 유저 documentID를 불러온다.
        db
            .collection("users").document(myUser.documentID)
            .collection("friends").whereField("state", isEqualTo: 2).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //데이터 중복을 막기 위해 원래 불러왔던 친구 목록을 삭제한다.
                myUser.friends.removeAll()
                //친구 숫자를 Label에 저장
                self.friendNumLabel.text = "(\(querySnapshot!.documents.count))"
                var count = 0
                for friendDocument in querySnapshot!.documents {
                    //친구의 documentID를 통해 친구의 users document 정보 접근
                    db
                        .collection("users").document(friendDocument.documentID).getDocument { (document, error) in
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
                                //테이블에 불러온 정보를 보여준다.
                                count += 1
                                //모든 친구 목록을 불러왔을 경우,
                                if count == querySnapshot!.documents.count {
                                    //테이블에 불러온 정보를 보여준다.
                                    self.myFriendsTableView.reloadData()
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                }
                
            }
        }
    }
    
    // ==================================================================>
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myFriendsTableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! MyFriendsTableViewCell
        cell.myFriendsName.text = myUser.friends[indexPath.row].name
        let data = try? Data(contentsOf: URL(string: myUser.friends[indexPath.row].profileImageURL)!)
        cell.myFriendsProfile.image = UIImage(data: data!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToSend = myUser.friends[indexPath.row]
        self.performSegue(withIdentifier: "toFriendProfile", sender: dataToSend)
        myFriendsTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
