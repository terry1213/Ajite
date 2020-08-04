//
//  ProfileViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/29.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {
   
    @IBOutlet weak var userNameLabel: UILabel!
    let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = user.profile.name
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
