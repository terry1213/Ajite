//
//  ManageFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//
protocol FriendUser {
    func onClickCell(index: Int)
}

import UIKit

class ManageFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var manageFriendProfile: UIImageView!
     
    @IBOutlet weak var manageFriendsName: UILabel!
    var cellDelegate : FriendUser?
    var delegate : ManageFriendViewCellDelegate?
    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteFriends(_ sender: Any) {
        cellDelegate?.onClickCell(index: (index?.row)!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol ManageFriendViewCellDelegate: AnyObject{
    func deletion(_ ManageFriendsTableViewCell: ManageFriendsTableViewCell)
}
