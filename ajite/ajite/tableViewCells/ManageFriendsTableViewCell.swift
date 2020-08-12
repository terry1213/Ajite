//
//  ManageFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit
protocol FriendUser {
    func onClickCell(index: Int)
}


class ManageFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var manageFriendProfile: CircleImageView!
    @IBOutlet weak var manageFriendsName: UILabel!
    @IBOutlet var deleteButton: UIButton!
    var cellDelegate : FriendUser?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func deleteFriends(_ sender: UIButton) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol ManageFriendViewCellDelegate: AnyObject{
    func deletion(_ ManageFriendsTableViewCell: ManageFriendsTableViewCell, index: Int)
}
