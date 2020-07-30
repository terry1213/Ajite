//
//  ViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/25.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil){
            
        }else{
            
        }
        
    }
    
    /*
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError){
        if (error == nil){
            
        }
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self//uiDelegate to delegate
        GIDSignIn.sharedInstance()?.signIn()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
