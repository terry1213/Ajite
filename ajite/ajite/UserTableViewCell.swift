//
//  UserTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBAction func didClickButton(){
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
