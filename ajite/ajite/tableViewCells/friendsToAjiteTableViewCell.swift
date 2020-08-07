//
//  friendsToAjiteTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/05.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

class friendsToAjiteTableViewCell: UITableViewCell {

    @IBOutlet weak var addedFriendsName: UILabel!
    @IBOutlet weak var addedFriendsProfile: CircleImageView!
    @IBOutlet weak var searchFriendsName: UILabel!
    @IBOutlet weak var searchFriendsProfile: CircleImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//소속: CreateAjiteViewController
//Description: Create Ajite 화면에서 친구 추가를 누를때 뷰 화면이 하나 뜬다. 거기에 사용되는 셀
