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
        userNameLabel.text = myUser.name
        getData()
        bio.text = myUser.bio
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
    func getData(){
            db
                .collection("users").document(myUser.documentID)
                .collection("friends").whereField("state", isEqualTo: 2).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    myUser.friends.removeAll()
                    var temUser : User
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        temUser = User()
                        temUser.userID = data["userID"] as! String
                        temUser.name = data["name"] as! String
                        temUser.documentID = document.documentID
                        myUser.friends.append(temUser)
                    }
                    DispatchQueue.main.async{
                        //테이블에 불러온 정보를 보여준다.
                        self.myFriendsTableView.reloadData()
                    }
                }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myFriendsTableView.deselectRow(at: indexPath, animated: true)
    }
}
