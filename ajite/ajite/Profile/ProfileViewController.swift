//
//  ProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var friendNumLabel: UILabel!
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var myFriendsTableView: UITableView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addFriend.imageView?.contentMode = .scaleAspectFit
        self.myFriendsTableView.delegate = self
        self.myFriendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        self.userNameLabel.text = myUser.name
        self.bio.text = myUser.bio
        let data = try? Data(contentsOf: URL(string: myUser.profileImageURL)!)
        self.profilePicture.image = UIImage(data: data!)
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataToSend = myUser.friends[indexPath.row]
        self.performSegue(withIdentifier: "toFriendProfile", sender: dataToSend)
        myFriendsTableView.deselectRow(at: indexPath, animated: true)
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
    
    func getData(){
            db
                .collection("users").document(myUser.documentID)
                .getDocument { (document, error) in
                    if let document = document, document.exists {
                        myUser.bio = document.data()!["bio"] == nil ? "" : document.data()!["bio"] as! String
                    } else {
                        print("Document does not exist")
                    }
                }
            db
                .collection("users").document(myUser.documentID)
                .collection("friends").whereField("state", isEqualTo: 2).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    myUser.friends.removeAll()
                    //self.myFriendsTableView.reloadData()
                    self.friendNumLabel.text = "(\(querySnapshot!.documents.count))"
                    var count = 0
                    for friendDocument in querySnapshot!.documents {
                        db
                            .collection("users").document(friendDocument.documentID).getDocument { (document, error) in
                                var temUser : User
                                if let document = document, document.exists {
                                    temUser = User()
                                    let data = document.data()
                                    temUser.userID = data!["userID"] as! String
                                    temUser.name = data!["name"] as! String
                                    temUser.profileImageURL = data!["profileImageURL"] as! String
                                    temUser.documentID = document.documentID
                                    myUser.friends.append(temUser)
                                    //테이블에 불러온 정보를 보여준다.
                                    count += 1
                                    if count == querySnapshot!.documents.count {
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
    
}
