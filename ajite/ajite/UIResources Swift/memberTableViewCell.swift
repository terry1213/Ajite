//
//  memberTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/05.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class memberTableViewCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var profilePicture: CircleImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}