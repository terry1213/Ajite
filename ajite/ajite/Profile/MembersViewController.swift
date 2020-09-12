//
//  MembersViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MembersViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var membersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inviteFriends(_ sender: Any) {
        print("pressed Invite button")
    }
    
  
    

}
