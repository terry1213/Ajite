//
//  searchFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class searchFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var searchFriendImage: CircleImageView!
    
    @IBOutlet weak var searchFriendName: UILabel!
    
    let searchUser = User()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//소속: FriendsToAjiteViewController
//Description: 아지트에 멤버 추가할때 추가할 자기 친구들을 여기에 집어 넣는다 
