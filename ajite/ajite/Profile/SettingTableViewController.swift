//
//  SettingTableViewController.swift
//  ajite
//
//  Created by 임연우 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import KakaoSDKUser

class SettingTableViewController: UITableViewController {
    
    // ======================> 변수, outlet 선언
    
    
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    
    
    // ==================================================================>
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //로그아웃 버튼 클릭 시
        if indexPath.section == 1 && indexPath.row == 0 {
            //구글 로그아웃 작업 실행
            GIDSignIn.sharedInstance().signOut()
            //firebase 로그아웃
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            
            //카카오톡 로그아웃
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
            
            //로그인 화면으로 이동
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(identifier: "LoginViewControllers")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginController)
        }
    }

}
