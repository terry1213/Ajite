//
//  InvitationTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/09/09.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class InvitationTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var invitationMessage: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
