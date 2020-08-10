//
//  BiographyViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class BiographyViewController: UIViewController {
    
   
    @IBOutlet weak var biographyTF: UITextField!
    var changed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 바이오그래피는 최소 100자 100자 이상은 못 받게 함
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = biographyTF.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 100
    }
    
    @IBAction func changedBio(_ sender: Any) {
        changed = true
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        if changed {
            myUser.bio = biographyTF.text!
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
        dismiss(animated: true)
    }

}

