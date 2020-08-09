//
//  UserTableViewCell.swift
//  ajite
//
//  Created by Chanwoong Ahn on 2020/08/07.
//  Copyright © 2020 ajite. All rights reserved.
//

import UIKit

protocol TableViewUser {
    func onClickCell(index: Int)
}

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    var cellDelegate: TableViewUser?
    weak var delegate : UserTableViewCellDelegate?
    var index: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sendRequest(_ sender: UIButton) {
        cellDelegate?.onClickCell(index: (index?.row)!)
   
    }
    
    @IBAction func popUpAlert(_ sender: Any) {
       if let delegate = delegate{
            self.delegate?.sendMessage(self)
        }
    }
}

protocol UserTableViewCellDelegate : AnyObject{
    func sendMessage(_ UserTableViewCell: UserTableViewCell)
}
