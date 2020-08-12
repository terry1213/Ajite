//
//  searchFriendsTableViewCell.swift
//  ajite
//
//  Created by 노은솔 on 2020/08/08.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

/*
protocol searchUser {
    func onClickCell(index: Int)
}*/

class searchFriendsTableViewCell: UITableViewCell {

    @IBOutlet var searchFriendImage: CircleImageView!
    
    @IBOutlet var searchFriendName: UILabel!
    //var cellDelegate: searchUser?
    //weak var delegate: searchTableViewCellDelegate?
    var index: IndexPath?
    
    let searchUser = User()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addToUnderTable(_ sender: Any) {
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
/*
protocol searchTableViewCellDelegate: AnyObject{
    func sendToAddedTable(_ searchFriendsTableViewCell: searchFriendsTableViewCell)
}*/
//소속: FriendsToAjiteViewController
//Description: 아지트에 멤버 추가할때 추가할 자기 친구들을 여기에 집어 넣는다 
