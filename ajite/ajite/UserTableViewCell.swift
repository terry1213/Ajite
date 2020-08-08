//
//  UserTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol TableViewUser {
    func onClickCell(index: Int)
}

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    var cellDelegate: TableViewUser?
    var index: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sendRequest(_ sender: Any) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
}
