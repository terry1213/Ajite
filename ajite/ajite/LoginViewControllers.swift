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
            guard let authentification = user.authentication else {return}
                    let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                      if let error = error {
                        let authError = error as NSError
                        if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                          // The user is a multi-factor user. Second factor challenge is required.
                          let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                          var displayNameString = ""
                          for tmpFactorInfo in (resolver.hints) {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                          }
                        } else {
                          //self.showMessagePrompt(error.localizedDescription)
                          return
                        }
                        // ...
                        return
                      }
                      // User is signed in
                      // ...
                    }
            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            vcName?.modalTransitionStyle = .coverVertical
            self.present(vcName!, animated: true, completion: nil)
        }else{
            
        }
        
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError){
        if (error == nil){
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self//uiDelegate to delegate
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
