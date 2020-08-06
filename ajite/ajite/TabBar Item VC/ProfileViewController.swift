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
   
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        userNameLabel.text = user.profile.name
        
        myUser.name = user.profile.name
        // Do any additional setup after loading the view.
    }
    

}
