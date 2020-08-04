//
//  NewPlaylistViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/03.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit


protocol playlistDelegate {
    func addToPlaylist(name :  String)
}

class NewPlaylistViewController: UIViewController {

    var delegate:playlistDelegate?
    
    @IBOutlet weak var userSpecifiedPlaylistName: UITextField!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        //userSpecifiedPlaylistName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createPlaylist(_ sender: Any) {
     
        if self.delegate != nil && self.userSpecifiedPlaylistName.text != nil {
            let dataToBeSent = self.userSpecifiedPlaylistName.text
            self.delegate?.addToPlaylist(name: dataToBeSent!)
        }

        dismiss(animated: true)
    }
   

}

extension NewPlaylistViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
