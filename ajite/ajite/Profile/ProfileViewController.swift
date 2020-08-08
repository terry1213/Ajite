//
//  ProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import GoogleSignIn

var myUser =  User()

class ProfileViewController: UIViewController {
   
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var myFriendsTableView: UITableView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        userNameLabel.text = user.profile.name
        myUser.name = user.profile.name
        // Do any additional setup after loading the view.
       addFriend.imageView?.contentMode = .scaleAspectFit
        self.myFriendsTableView.delegate = self
        self.myFriendsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bio.text = myUser.bio
    }

}


extension ProfileViewController : UITableViewDelegate{
    
}

extension ProfileViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUser.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myFriendsTableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as! MyFriendsTableViewCell
        cell.myFriendsName.text = myUser.friends[indexPath.row].name
        
//!!!!!!!!!!!!!!!!!!!!!!!! 여기 수정 해주세요 !!!!!!!!!!!!!!!!!!!!!
        
        cell.myFriendsProfile.image = UIImage(named: playlists[indexPath.row].playlistImageString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
            return 60
         }
}
