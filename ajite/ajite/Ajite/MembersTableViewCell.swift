//
//  MembersTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/10.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    @IBAction func addFriend(_ sender: Any) {
        print("pressed Added")
    }
    
}
