//
//  ShareSongsViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/04.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class ShareSongsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        
        if touch.view == self.view {
            dismiss(animated: true)
        }
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
