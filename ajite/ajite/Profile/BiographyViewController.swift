//
//  BiographyViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class BiographyViewController: UIViewController {
    
    // ======================> 변수, outlet 선언
    
    var changed = false
    @IBOutlet weak var biographyTF: UITextField!
    
    // ==================================================================>
    
    // ======================> ViewController의 이동이나 Loading 될때 사용되는 함수들
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //유저의 기존 biography 불러오기
        biographyTF.text = myUser.bio
    }
    
    // ==================================================================>
    
    // ======================> Event가 일어난 경우 호출되는 Action 함수들
    
    @IBAction func changedBio(_ sender: Any) {
        changed = true
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        if changed {
            //전역 변수에 biography 새로 저장
            myUser.bio = biographyTF.text!
        }
        //화면 내리기
        dismiss(animated: true)
    }
    
    // ==================================================================>
    
    // ======================> Firestore에서 데이터를 가져오거나 저장하는 함수들
    
    func chageBio() {
        db
            .collection("users").document(myUser.documentID).updateData([
                "bio" : biographyTF.text!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("User's bio successfully updated")
                }
        }
    }
    
    // ==================================================================>
    
    
    // 바이오그래피는 최소 100자 100자 이상은 못 받게 함
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = biographyTF.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 100
    }
    
    //keyboard 아무 곳이나 터치하면 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    //keyboard return누르면 숨겨짐
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

