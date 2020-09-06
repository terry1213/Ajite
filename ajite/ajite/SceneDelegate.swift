//
//  SceneDelegate.swift
//  ajite
//
//  Created by 노은솔 on 2020/07/25.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // add these lines
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //카카오톡 자동 로그인
        self.autoKakaoLogin()
        
        //구글 자동 로그인
        self.autoGoogleLogin()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        //root view controller를 vc로 변경
        window.rootViewController = vc
        
        //변경 애니메이션 적용
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func kakaoLogin() {
        AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                self.getKakaoUserData()
            }
        }
    }
    
    func autoGoogleLogin() {
        //이미 로그인한 구글 계정이 있다면
        guard let signIn = GIDSignIn.sharedInstance() else { return }
        //만약 이미 로그인을 한 유저라면
        if (signIn.hasPreviousSignIn()) {
            //이전 아이디로 로그인
            signIn.restorePreviousSignIn()
        }
    }
    
    func autoKakaoLogin() {
        //이미 로그인된 카카오톡 계정이 있다면
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error {
                print(error)
            }
            else {
                print("accessTokenInfo() success.")
                self.getKakaoUserData()
            }
        }
    }
    
    func getKakaoUserData() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //user?.kakaoAccount?.email as! String
                myUser = User()
                myUser.documentID = "\(user?.id ?? 0)"
                myUser.userID = "\(user?.id ?? 0)"
                myUser.name = user?.kakaoAccount?.profile?.nickname as! String
                myUser.profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString as? String ?? "https://firebasestorage.googleapis.com/v0/b/ajite-13729.appspot.com/o/profileImageDefault.jpeg?alt=media&token=f02f4566-3ce6-467d-a14c-e816eafd2e93"
                
                
                let db = Firestore.firestore()
                db.collection("users").document(myUser.documentID).setData([
                    "userID": myUser.userID as Any,
                    "name": myUser.name as Any,
                    "profileImageURL": myUser.profileImageURL as Any
                ], merge: true) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("User document added")
                    }
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarMenuViewController = storyboard.instantiateViewController(identifier: "TabBarMenuViewController")
                        
                //root view controller를 LoginViewControllers에서 TabBarMenuViewController로 전환
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarMenuViewController)
            }
        }
    }
}
