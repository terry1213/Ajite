//
//  BiographyViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class BiographyViewController: UIViewController {
    
    @IBOutlet weak var biographyTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        biographyTextField.delegate = self

    }
    
    

}

extension BiographyViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        myUser.bio = biographyTextField.text
    }
}
