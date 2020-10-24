//
//  NotificationTableViewController.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    @IBOutlet weak var ajiteInvites: UITableViewCell!
    @IBOutlet weak var songInbox: UITableViewCell!
    @IBOutlet weak var friendRequest: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "gradient1"))
        self.friendRequest.backgroundColor = .clear
        self.songInbox.backgroundColor = .clear
        self.ajiteInvites.backgroundColor = .clear
    }
  
}
