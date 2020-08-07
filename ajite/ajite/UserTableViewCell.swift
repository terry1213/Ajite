//
//  UserTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var nameBox: UILabel!
    @IBOutlet var sendButton: UIButton!
    
    func configureCell(userDB: UserDB){
        nameBox.text = userDB.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
