//
//  MyFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {

 
    @IBOutlet weak var myFriendsName: UILabel!
    @IBOutlet weak var myFriendsProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// 소속: ProfileViewController
//Description: 유저의 친구들을 저장해둔 셀
